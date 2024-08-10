# [[ AUTOCOMPLETE ]]
# Basic auto/tab complete:
autoload -Uz compinit
zmodload zsh/complist
compinit -C
_comp_options+=(globdots)		# Include hidden files.



# [[ SUPPLEMENTARY SCRIPTS ]]
for config in "$ZDOTDIR"/plugin/*.zsh ; do
    source "$config"
done
unset -v config



# [[ VI-MODE ]]
bindkey -v # vi mode
export KEYTIMEOUT=1 #esc works instantly

function zle-keymap-select () {
case $KEYMAP in
  vicmd) echo -ne '\e[1 q';; # block
  viins|main) echo -ne '\e[5 q';; # beam
esac
}
zle -N zle-keymap-select
echo -ne "\e[5 q"
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# Use vim keys in tab complete menu:
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char
bindkey -M menuselect '^j' vi-down-line-or-history



# [[ HISTORY ]]
HISTSIZE=1000000
SIZEHIST=1000000
HISTFILE="$XDG_CACHE_HOME"/history.zsh



# [[ OPTIONS ]]
setopt extendedglob nomatch interactive_comments hist_ignore_space
# from cs machines
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
# zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true



# [[ PLUGINS ]]
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(fasd --init auto)"
eval "$(fzf --zsh)"



# [[ PROMPT ]]
# PS1='%F{blue}%~ %(?.%F{green}.%F{blue})❯%f '
eval "$(starship init zsh)"



# # -- Use fd instead of fzf --
# export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
#
# # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# # - The first argument to the function ($1) is the base path to start traversal
# # - See the source code (completion.{bash,zsh}) for the details.
# _fzf_compgen_path() {
#   fd --hidden --exclude .git . "$1"
# }
#
# # Use fd to generate the list for directory completion
# _fzf_compgen_dir() {
#   fd --type=d --hidden --exclude .git . "$1"
# }
