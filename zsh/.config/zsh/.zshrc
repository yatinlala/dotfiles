# theme.sh $(lark print)
# some useful options (man zshoptions)
setopt autocd extendedglob nomatch
setopt interactive_comments
zle_highlight=('paste:none')
unsetopt BEEP # Beeping sucks

# # Enable colors and change prompt:
# autoload -Uz colors && colors	# Load colors
# PROMPT="%{$fg_bold[cyan]%}%~ %{$fg_bold[green]%}➜ %{$reset_color%}"
# stty stop undef		# Disable ctrl-s to freeze terminal.
# setopt interactive_comments

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$XDG_CACHE_HOME"/history.zsh

# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -C
_comp_options+=(globdots)		# Include hidden files.

#from cs machines
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

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

clear-screen-scrollback-insert () {
  echo -ne '\033c' # clear scrollback buffer as well
  zle .clear-screen
  echo -ne "\e[6 q"
}

zle -N clear-screen-scrollback
zle -N clear-screen-scrollback-insert

# clear screen scrolleback keybindings
bindkey -M main '^K' clear-screen-scrollback
bindkey -M viins '^K' clear-screen-scrollback-insert
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

# lf() {
#     $HOME/code/scripts/lf/lf
# }

# tmux-sessionizer() {
#     $HOME/code/scripts/tmux-sessionizer
# }

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

zle -N lf
bindkey '^a' lf

# zle -N tmux-sessionizer
# bindkey '^f' tmux-sessionizer

lark-toggle() {
    lark toggle
}
zle -N lark-toggle
bindkey '^y' lark-toggle

# Edit line in vim with e:
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd e edit-command-line

########## LOAD PLUGINS ##########
# source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#Source aliases
source "$ZDOTDIR/zshaliases"

# # Create a tmux session if none exist
# case $- in *i*)
#     if [[ "$SSH_CONNECTION" == "" ]]; then
#         if [ -z "$TMUX" ]; then
#             tmux new-session -A -s main neww -t main:
#         fi
#     fi
# esac

if [[ -v NVIM ]];
then
    EDITOR="nvrl"
fi

eval "$(fasd --init auto)"
# eval "$(starship init zsh)"
source $XDG_DATA_HOME/zsh/agkozak-zsh-prompt/agkozak-zsh-prompt.plugin.zsh
AGKOZAK_BLANK_LINES=1 
AGKOZAK_MULTILINE=0
AGKOZAK_USER_HOST_DISPLAY=0
AGKOZAK_PROMPT_CHAR=( ❯ ❯ ❮ )
AGKOZAK_COLORS_PROMPT_CHAR='yellow'

# opam configuration
[[ ! -r /home/nitay/.local/share/opam/opam-init/init.zsh ]] || source /home/nitay/.local/share/opam/opam-init/init.zsh  > /dev/null 2> /dev/null
