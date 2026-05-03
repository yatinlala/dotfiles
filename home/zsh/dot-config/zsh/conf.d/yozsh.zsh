# yozsh — AI shell assistant for kitty + zsh
#
# Requirements:
#   - kitty with allow_remote_control yes in kitty.conf
#   - curl and jq
#   - ~/io/anthropickey containing your Anthropic API key
#
# Install:
#   source /path/to/yozsh.zsh   (add this line to your .zshrc)
#
# Usage:
#   Type yo <your-request> and press enter.

ANTHROPIC_API_KEY=$(<~/io/anthropickey)
YOZSH_SCROLLBACK_LENGTH=1000

_YO_PREFIX=$'\033[3;36m'   # italic cyan (matches yosh)
_YO_RESET=$'\033[0m'

# trick syntax highlighting into treating yo as a real command
yo() {}

_yo_tools='[
  {
    "name": "command",
    "description": "Generate a shell command for the user to review and execute. The command will be prefilled at the prompt for the user to edit or submit.",
    "input_schema": {
      "type": "object",
      "properties": {
        "command":     {"type": "string", "description": "The shell command to execute"},
        "explanation": {"type": "string", "description": "One-line explanation shown to the user"}
      },
      "required": ["command", "explanation"]
    }
  },
  {
    "name": "chat",
    "description": "Respond with text when no shell command should be generated. Use this for conversational replies, explanations, Q&A, brainstorming, and creative requests.",
    "input_schema": {
      "type": "object",
      "properties": {
        "response": {"type": "string", "description": "Your text response"}
      },
      "required": ["response"]
    }
  }
]'

_yo_call_llm() {
  local query="$1"

  # Strip control characters from scrollback before passing to jq.
  # kitty @ get-text can include CR, ESC remnants, etc. even without --ansi;
  # unescaped U+0000-U+001F chars cause jq string parse errors.
  # We keep tab (0x09) and newline (0x0A), remove everything else in that range.
  local scrollback=$(kitty @ get-text --extent=all 2>/dev/null \
    | tr -d '\000-\010\013-\037\177' \
    | tail -n $YOZSH_SCROLLBACK_LENGTH)

  local payload=$(jq -n \
    --arg  q     "$query" \
    --arg  sb    "$scrollback" \
    --argjson tools "$_yo_tools" \
    '{
      model:    "claude-sonnet-4-20250514",
      max_tokens: 1024,
      system:   "You are an assistant called yozsch running in a users shell. You are given recent terminal scrollback for context. You MUST respond using one of the two tools, consult the descriptions to determine which tool is appropriate. Be brief.",
      messages: [{
        role: "user",
        content: (if ($sb | length) > 0 then
          "<terminal_scrollback>\n" + $sb + "\n</terminal_scrollback>\n\n" + $q
        else
          $q
        end)
      }],
      tools: $tools,
      tool_choice: {type: "any"}
    }')

  if [[ $? -ne 0 ]] || [[ -z "$payload" ]]; then
    print "yozsh: failed to build request payload" >&2
    return 1
  fi

  local response
  response=$(curl -sf \
    --max-time 30 \
    -X POST "https://api.anthropic.com/v1/messages" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "content-type: application/json" \
    -d "$payload")

  if [[ $? -ne 0 ]]; then
    print "yozsh: curl failed" >&2
    return 1
  fi

  print -r -- "$response"
}

# Chat responses are deferred to precmd so they print above a fresh prompt.
_yo_pending_chat=""

_yo_precmd() {
  if [[ -n "$_yo_pending_chat" ]]; then
    print "${_YO_PREFIX}${_yo_pending_chat}${_YO_RESET}"
    _yo_pending_chat=""
  fi
}
add-zsh-hook precmd _yo_precmd

_yo_accept_line() {
  POSTDISPLAY=""
  zle -R   # clear autosuggestion ghost text from terminal

  if [[ $BUFFER != yo\ * ]]; then
    zle .accept-line
    return
  fi

  local original_buffer="$BUFFER"
  local query=${BUFFER#yo }
  zle -R "Thinking..."

  local response
  response=$(_yo_call_llm "$query")
  local rc=$?

  if (( rc != 0 )) || [[ -z "$response" ]]; then
    BUFFER=""
    CURSOR=0
    zle .accept-line
    return 1
  fi

  if ! print -r -- "$response" | jq -e . >/dev/null 2>&1; then
    local preview
    preview=$(printf '%s' "$response" | tr '\n' ' ' | cut -c1-300)
    print "yozsh: API returned non-JSON response" >&2
    [[ -n "$preview" ]] && print "yozsh: response preview: $preview" >&2
    BUFFER=""
    CURSOR=0
    zle .accept-line
    return 1
  fi

  local api_error
  api_error=$(print -r -- "$response" | jq -r 'if .error then (.error.type // "error") + ": " + (.error.message // "unknown error") else empty end' 2>/dev/null)
  if [[ -n "$api_error" ]]; then
    print "yozsh: API error: $api_error" >&2
    BUFFER=""
    CURSOR=0
    zle .accept-line
    return 1
  fi

  local tool
  tool=$(print -r -- "$response" | jq -r '[.content[] | select(.type=="tool_use")][0].name // empty' 2>/dev/null)

  case "$tool" in
    command)
      local cmd explanation
      cmd=$(print -r -- "$response" | jq -r '[.content[] | select(.type=="tool_use" and .name=="command")][0].input.command // empty')
      explanation=$(print -r -- "$response" | jq -r '[.content[] | select(.type=="tool_use" and .name=="command")][0].input.explanation // empty')
      # Set buffer directly — ZLE redraws the line in place, replacing the yo query.
      # Explanation goes in the ZLE message area below the buffer line.
      BUFFER="$cmd"
      CURSOR=${#BUFFER}
      [[ -n "$explanation" ]] && zle -M "$explanation"
      ;;

    chat)
      local msg
      msg=$(print -r -- "$response" | jq -r '[.content[] | select(.type=="tool_use" and .name=="chat")][0].input.response // empty')
      _yo_pending_chat="$msg"
      BUFFER="$original_buffer"
      CURSOR=${#BUFFER}
      zle .accept-line
      ;;

    *)
      local response_type response_keys stop_reason content_types first_text
      response_type=$(print -r -- "$response" | jq -r '.type // "missing"' 2>/dev/null)
      response_keys=$(print -r -- "$response" | jq -r 'keys | join(",")' 2>/dev/null)
      stop_reason=$(print -r -- "$response" | jq -r '.stop_reason // "unknown"' 2>/dev/null)
      content_types=$(print -r -- "$response" | jq -r '[.content[]?.type] | join(",")' 2>/dev/null)
      first_text=$(print -r -- "$response" | jq -r '[.content[] | select(.type=="text")][0].text // empty' 2>/dev/null)
      print "yozsh: unexpected response (tool=${tool:-none}, type=${response_type:-missing}, stop_reason=${stop_reason:-unknown}, content_types=${content_types:-unknown})" >&2
      [[ -n "$response_keys" ]] && print "yozsh: response keys: $response_keys" >&2
      [[ -n "$first_text" ]] && print "yozsh: first text block: $first_text" >&2
      BUFFER="$original_buffer"
      CURSOR=${#BUFFER}
      zle .accept-line
      ;;
  esac
}

zle -N _yo_accept_line
bindkey -M viins '^M' _yo_accept_line
bindkey -M viins '^J' _yo_accept_line
