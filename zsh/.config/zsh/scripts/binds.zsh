# vi mode
bindkey -v
export KEYTIMEOUT=1

# # Use vim keys in tab complete menu:
# bindkey -M menuselect '^h' vi-backward-char
# bindkey -M menuselect '^k' vi-up-line-or-history
# bindkey -M menuselect '^l' vi-forward-char
# bindkey -M menuselect '^j' vi-down-line-or-history

clear-screen-scrollback () {
  echo -ne '\033c' # clear scrollback buffer as well
  zle .clear-screen
}

clear-screen-scrollback-insert () {
  echo -ne '\033c' # clear scrollback buffer as well
  zle .clear-screen
  echo -ne "\e[6 q"
}

zle -N clear-screen-scrollback
zle -N clear-screen-scrollback-insert

# clear screen scrolleback keybindings
bindkey -M main '^[k' clear-screen-scrollback
bindkey -M viins '^[k' clear-screen-scrollback-insert
bindkey -M vicmd '^[k' clear-screen-scrollback

bindkey -M main '^[l' clear-screen

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[2 q';;      # block
        viins|main) echo -ne '\e[6 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[6 q"
}
zle -N zle-line-init

# Use lf to switch directories
lf() {
    tmp="$(mktemp)"
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

zle -N lf
bindkey '^a' lf

# tmux-sessionizer() {
#     $HOME/code/scripts/tmux-sessionizer
# }

# zle -N tmux-sessionizer
# bindkey '^f' tmux-sessionizer

# FZF
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(echo "fzf")) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget

ff() {
    files_list="$(fzf -m)"
    return_code="$?"

    if [ "$return_code" -ne 0 ]; then
        echo "Nothing to do; fzf return_code = $return_code"
        return "$return_code"
    fi

    echo "FILES SELECTED:"
    echo "$files_list"

    # Convert the above list of newline-separated file names into an array
    # - See: https://stackoverflow.com/a/24628676/4561887
    SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
    IFS=$'\n'      # Change IFS to newline char
    files_array=($files_list) # split this newline-separated string into an array
    IFS=$SAVEIFS   # Restore original IFS

    # Call vim with each member of the array as an argument
    nvim "${files_array[@]}"
}


lark-toggle() {
    lark toggle
}
zle -N lark-toggle
bindkey '^y' lark-toggle

# Edit line in vim with ^e:
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd '^e' edit-command-line
