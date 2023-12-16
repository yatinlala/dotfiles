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
HISTSIZE=100000
SAVEHIST=100000
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

########## LOAD PLUGINS ##########
# source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#Source aliases
# source "$ZDOTDIR/zshaliases"
# Load any supplementary scripts
for config in "$ZDOTDIR"/scripts/*.zsh ; do
    source "$config"
done
unset -v config

# # Create a tmux session if none exist
# case $- in *i*)
#     if [[ "$SSH_CONNECTION" == "" ]]; then
#         if [ -z "$TMUX" ]; then
#             tmux new-session -A -s main neww -t main:
#         fi
#     fi
# esac

eval "$(fasd --init auto)"
# eval "$(starship init zsh)"

# opam configuration
[[ ! -r /home/nitay/.local/share/opam/opam-init/init.zsh ]] || source /home/nitay/.local/share/opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# Some fun
# git() {
#     if [ "$1" = "pull" ]; then
#         echo "WARNING: 'git pull' has been deprecated, use 'git tug' instead."
#         echo "git: 'foo' is not a git command. See 'git --help'."
#         echo "The most similar command is"
#         echo "  hook"
#     else
#         command git "$@"
#     fi
# }

# pfetch


if [ -z "$TMUX" ]; then
    muxterm mix
fi
