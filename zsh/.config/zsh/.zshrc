# some useful options (man zshoptions)
setopt autocd extendedglob nomatch
setopt interactive_comments
zle_highlight=('paste:none')
unsetopt BEEP # Beeping sucks

# Enable colors and change prompt:
autoload -Uz colors && colors	# Load colors
PROMPT="%{$fg_bold[cyan]%}%~ %{$fg_bold[green]%}➜ %{$reset_color%}"
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$XDG_CACHE_HOME"/history.zsh

# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -C
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char
bindkey -M menuselect '^j' vi-down-line-or-history

clear-screen-scrollback () {
  echo -ne '\033c' # clear scrollback buffer as well
  zle .clear-screen
}

zle -N clear-screen-scrollback

# clear screen scrolleback keybindings
bindkey -M main '^K' clear-screen-scrollback
bindkey -M viins '^K' clear-screen-scrollback
bindkey -M vicmd '^K' clear-screen-scrollback


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
echo -ne '\e[6 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories
lf() {
    tmp="$(mktemp)"
    $HOME/code/scripts/lf/lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}


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

zle     -N   lf
bindkey '^a' lf

bindkey -s '^f' "tmux-sessionizer\n"

# Edit line in vim with e:
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd e edit-command-line

########## LOAD PLUGINS ##########
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#Source aliases
source "$ZDOTDIR/zshaliases"

