# ============
# Basic Settings 
# ============

# Load Colors
autoload -U colors && colors

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


# =================================
# custom widgets and behaviors
# =================================


# Completions
fpath=("$zshdatadir/completions" $fpath)
setopt nocomplete_aliases completeinword
zstyle ':completion:*' menu select

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

# Source environment Variables
source /home/nitay/.zprofile

# Source aliases
source /home/nitay/.config/zsh/aliases

SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_CHAR_SYMBOL=❯
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_HG_SHOW=false
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_NODE_SHOW=false
SPACESHIP_RUBY_SHOW=false
SPACESHIP_ELM_SHOW=false
SPACESHIP_ELIXIR_SHOW=false
SPACESHIP_XCODE_SHOW_LOCAL=false
SPACESHIP_SWIFT_SHOW_LOCAL=false
SPACESHIP_GOLANG_SHOW=false
SPACESHIP_PHP_SHOW=false
SPACESHIP_RUST_SHOW=false
SPACESHIP_JULIA_SHOW=false
SPACESHIP_DOCKER_SHOW=false
SPACESHIP_DOCKER_CONTEXT_SHOW=false
SPACESHIP_AWS_SHOW=false
SPACESHIP_CONDA_SHOW=false
SPACESHIP_VENV_SHOW=false
SPACESHIP_PYENV_SHOW=false
SPACESHIP_DOTNET_SHOW=false
SPACESHIP_EMBER_SHOW=false
SPACESHIP_KUBECONTEXT_SHOW=false
SPACESHIP_TERRAFORM_SHOW=false
SPACESHIP_TERRAFORM_SHOW=false
SPACESHIP_VI_MODE_SHOW=false
SPACESHIP_JOBS_SHOW=false

pfetch
# Spaceship Prompt
autoload -U promptinit; promptinit
prompt spaceship
