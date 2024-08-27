source $XDG_DATA_HOME/zsh-defer/zsh-defer.plugin.zsh

# [[ AUTOCOMPLETE ]]
# Basic auto/tab complete:
autoload -Uz compinit
zmodload zsh/complist
zsh-defer compinit -C
_comp_options+=(globdots)		# Include hidden files.


# [[ SUPPLEMENTARY SCRIPTS ]]
for config in "$ZDOTDIR"/conf.d/*.zsh ; do
    zsh-defer source "$config"
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



# [[ OPTIONS ]]
setopt nomatch interactive_comments hist_ignore_space
# from cs machines
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate # order of completer preferences
zstyle ':completion:*' format 'Completing %d' # specify whether you are completing option, filename, etc.
# zstyle ':completion:*' group-name '' #don't separate completions by group name
zstyle ':completion:*' menu select=2 # two options max visible at time
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# zstyle ':completion:*' menu select=long
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true



# [[ PLUGINS ]]
zsh-defer source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
zsh-defer source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zsh-defer eval "$(fasd --init auto)"
zsh-defer eval "$(fzf --zsh)"



# [[ PROMPT ]]
# PS1='%F{blue}%~ %(?.%F{green}.%F{blue})❯%f '
eval "$(starship init zsh)"
