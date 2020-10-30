# If not running interactively, don't do anything
[[ $- != *i* ]] && return


alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias sudo='sudo '
alias ls='ls --color=auto'
alias la='ls -a' 
alias vim='nvim'
alias v='vim'

alias z='zathura'
alias r='ranger'

alias f="find . -maxdepth 4 | fzf --cycle --border --no-unicode --info=inline"
alias fp="find . -maxdepth 4 | fzf --preview='head -$LINES {}' --cycle --border --no-unicode --info=inline"

alias devour='devour '
alias d='devour'

alias libreoffice='d libreoffice'
alias feh='d feh'
alias zathura='d zathura'
alias mpv='d mpv'
alias emacs='d emacs'

alias ss='cd ~/.local/scripts'
alias wmc='nvim ~/.config/i3/config'
alias zshc='nvim ~/.config/zsh/.zshrc'
alias compc='cd ~/.local/compiled'

alias tp='trash-put'
alias te='trash-empty'
alias tl='trash-list'
alias tr='trash-restore'
alias tm='trash-remove'

# Smartly set terminal prompt depending on whether we're in ranger
if [ -z "$RANGER_LEVEL" ]; then 
  prompt_sym='%#'
elif [ "$RANGER_LEVEL" -le 1 ]; then 
  prompt_sym="←"
else
  prompt_sym=$(expr "$RANGER_LEVEL" - 1)
fi
PROMPT="%B[%c %(?..%F{black})$prompt_sym%F{fg}]%f%b "           
RPROMPT='%(?..%F{black}%B%?%b%F{fg})'
unset prompt_sym

# I dont know what this does
fpath=("$zshdatadir/completions" $fpath)
setopt nocomplete_aliases completeinword
zstyle ':completion:*' menu select

# Doom Emacs Commands
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="$HOME/.local/scripts:$PATH"

export PATH="$HOME/.local/bin:$PATH"

# ============
# key bindings
# ============

bindkey -v
KEYTIMEOUT=1

# vim keybindings
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^[[3~' delete-char
bindkey -M viins '^M' accept-line

# bash keybindings
bindkey -M main '^K' clear-screen-scrollback
bindkey -M viins '^K' clear-screen-scrollback
bindkey -M vicmd '^K' clear-screen-scrollback

# misc keybindings

# =================================
# custom widgets and behaviors
# =================================

# don't eat trailing spaces after autocompleting
ZLE_REMOVE_SUFFIX_CHARS=''

# change cursor style depending on mode
zle-keymap-select () {
  case $KEYMAP in
    vicmd)      echo -ne '\033[2 q';; # block cursor
    viins|main) echo -ne '\033[6 q';; # line cursor
  esac
}
zle-line-init () {
  echo -ne '\033[6 q' # line cursor
}
accept-line () {
  echo -ne '\033[2 q' # block cursor
  zle .accept-line
}

clear-screen-scrollback () {
  echo -ne '\033c' # clear scrollback buffer as well
  zle .clear-screen
}

# *lastly*, enable zsh completion module
autoload -Uz compinit
compinit

# load previously-defined custom widgets
zle -N zle-keymap-select
zle -N zle-line-init
zle -N accept-line
zle -N clear-screen-scrollback

# source and configure zsh autosuggestions
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Load zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

source /home/nitay/.zshenv
