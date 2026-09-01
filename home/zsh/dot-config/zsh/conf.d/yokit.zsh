# yokit
#
# Requirements:
#   - set allow_remote_control yes in kitty.conf
#   - llama-cli, timeout, and jq in path
#   - for the optional Anthropic backend: curl and ~/io/anthropickey
#   - source /path/to/yokit.zsh in your zshrc
#
# Usage:
#   Type yo <your-request> and press enter.
#
# Configuration:
#   YOKIT_BACKEND=local|anthropic (default: local)
#   YOKIT_LOCAL_MODEL=/path/to/model.gguf
#   YOKIT_GPU_LAYERS=all|N (default: all)

YOKIT_BACKEND=${YOKIT_BACKEND:-anthropic}
YOKIT_LOCAL_MODEL=${YOKIT_LOCAL_MODEL:-$HOME/.local/share/llms/unsloth/gemma-4-E2B-it-Q4_K_M.gguf}
YOKIT_LOCAL_TIMEOUT=${YOKIT_LOCAL_TIMEOUT:-45}
YOKIT_GPU_LAYERS=${YOKIT_GPU_LAYERS:-all}
YOKIT_LOCAL_SYSTEM_PROMPT=${YOKIT_LOCAL_SYSTEM_PROMPT:-"Translate the user request into one safe zsh command. Return only the command, with no Markdown or explanation."}
YOKIT_SCROLLBACK_LENGTH=1000

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

_yo_call_local() {
  local query="$1"
  local output_file

  if [[ ! -r "$YOKIT_LOCAL_MODEL" ]]; then
    print "yokit: local model is not readable: $YOKIT_LOCAL_MODEL" >&2
    return 1
  fi

  if ! (( $+commands[llama-cli] )); then
    print "yokit: llama-cli is not in PATH" >&2
    return 1
  fi

  output_file=$(mktemp /tmp/yokit.XXXXXX) || {
    print "yokit: failed to create temporary output file" >&2
    return 1
  }

  command timeout "${YOKIT_LOCAL_TIMEOUT}s" llama-cli \
    --model "$YOKIT_LOCAL_MODEL" \
    --system-prompt "$YOKIT_LOCAL_SYSTEM_PROMPT" \
    --prompt "$query" \
    --predict 128 \
    --temp 0 \
    --gpu-layers "$YOKIT_GPU_LAYERS" \
    --single-turn \
    --no-display-prompt \
    --no-show-timings \
    --no-warmup \
    --simple-io \
    --log-disable \
    --output "$output_file" \
    >/dev/null 2>&1
  local rc=$?

  if (( rc != 0 )); then
    rm -f -- "$output_file"
    if (( rc == 124 )); then
      print "yokit: local model timed out after ${YOKIT_LOCAL_TIMEOUT}s" >&2
    else
      print "yokit: llama-cli failed (exit $rc)" >&2
    fi
    return 1
  fi

  # llama-cli's output file contains a short chat transcript. Extract the
  # assistant turn and trim surrounding blank lines and optional code fences.
  local command_text
  command_text=$(awk '
    /^Assistant:$/ { capture = 1; next }
    capture { line[++count] = $0 }
    END {
      first = 1
      while (first <= count && line[first] ~ /^[[:space:]]*$/) first++
      last = count
      while (last >= first && line[last] ~ /^[[:space:]]*$/) last--
      if (line[first] ~ /^```(sh|bash|zsh)?[[:space:]]*$/ && line[last] ~ /^```[[:space:]]*$/) {
        first++
        last--
      }
      for (i = first; i <= last; i++) print line[i]
    }
  ' "$output_file")
  rm -f -- "$output_file"

  if [[ -z "$command_text" ]]; then
    print "yokit: local model returned no command" >&2
    return 1
  fi

  # Match the Anthropic tool response shape so the ZLE handling below works
  # identically for both backends.
  jq -n --arg command "$command_text" '{
    content: [{
      type: "tool_use",
      name: "command",
      input: {
        command: $command,
        explanation: ""
      }
    }]
  }'
}

_yo_call_anthropic() {
  local query="$1"

  if [[ -z "$ANTHROPIC_API_KEY" ]]; then
    if [[ ! -r "$HOME/io/anthropickey" ]]; then
      print "yokit: Anthropic API key not found at ~/io/anthropickey" >&2
      return 1
    fi
    ANTHROPIC_API_KEY=$(<"$HOME/io/anthropickey")
  fi

  # Strip control characters from scrollback before passing to jq.
  # kitty @ get-text can include CR, ESC remnants, etc. even without --ansi;
  # unescaped U+0000-U+001F chars cause jq string parse errors.
  # We keep tab (0x09) and newline (0x0A), remove everything else in that range.
  local scrollback=$(kitty @ get-text --extent=all 2>/dev/null \
    | tr -d '\000-\010\013-\037\177' \
    | tail -n $YOKIT_SCROLLBACK_LENGTH)

  local payload=$(jq -n \
    --arg  q     "$query" \
    --arg  sb    "$scrollback" \
    --argjson tools "$_yo_tools" \
    '{
      model:    "claude-sonnet-4-6",
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
    print "yokit: failed to build request payload" >&2
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
    print "yokit: curl failed" >&2
    return 1
  fi

  print -r -- "$response"
}

_yo_call_llm() {
  case "$YOKIT_BACKEND" in
    local)     _yo_call_local "$1" ;;
    anthropic) _yo_call_anthropic "$1" ;;
    *)
      print "yokit: unknown backend: $YOKIT_BACKEND (expected local or anthropic)" >&2
      return 1
      ;;
  esac
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
  zle -R "generating..."

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
    print "yokit: API returned non-JSON response" >&2
    [[ -n "$preview" ]] && print "yokit: response preview: $preview" >&2
    BUFFER=""
    CURSOR=0
    zle .accept-line
    return 1
  fi

  local api_error
  api_error=$(print -r -- "$response" | jq -r 'if .error then (.error.type // "error") + ": " + (.error.message // "unknown error") else empty end' 2>/dev/null)
  if [[ -n "$api_error" ]]; then
    print "yokit: API error: $api_error" >&2
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
      print "yokit: unexpected response (tool=${tool:-none}, type=${response_type:-missing}, stop_reason=${stop_reason:-unknown}, content_types=${content_types:-unknown})" >&2
      [[ -n "$response_keys" ]] && print "yokit: response keys: $response_keys" >&2
      [[ -n "$first_text" ]] && print "yokit: first text block: $first_text" >&2
      BUFFER="$original_buffer"
      CURSOR=${#BUFFER}
      zle .accept-line
      ;;
  esac
}

zle -N _yo_accept_line
bindkey -M viins '^M' _yo_accept_line
bindkey -M viins '^J' _yo_accept_line
