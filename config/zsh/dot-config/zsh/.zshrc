echo -ne "\e[5 q"

function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

# Clone and compile to wordcode missing plugins.
if [[ ! -e $XDG_DATA_HOME/zsh-syntax-highlighting ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $XDG_DATA_HOME/zsh-syntax-highlighting
  zcompile-many $XDG_DATA_HOME/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
fi
if [[ ! -e $XDG_DATA_HOME/zsh-autosuggestions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $XDG_DATA_HOME/zsh-autosuggestions
  zcompile-many $XDG_DATA_HOME/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi
if [[ ! -e $XDG_DATA_HOME/powerlevel10k ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $XDG_DATA_HOME/powerlevel10k
  make -C $XDG_DATA_HOME/powerlevel10k pkg
fi

# Activate Powerlevel10k Instant Prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable the "new" completion system (compsys).
autoload -Uz compinit && compinit
[[ $ZDOTDIR/.zcompdump.zwc -nt $ZDOTDIR/.zcompdump ]] || zcompile-many $ZDOTDIR/.zcompdump
unfunction zcompile-many
_comp_options+=(globdots)		# Include hidden files.
# # [[ AUTOCOMPLETE ]]
# # Basic auto/tab complete:
# autoload -Uz compinit
# zmodload zsh/complist
# compinit -C

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# [[ SUPPLEMENTARY SCRIPTS ]]
for config in "$ZDOTDIR"/conf.d/* ; do
    source "$config"
done
unset -v config

# [[ VI-MODE ]]
KEYTIMEOUT=1 #esc works instantly

function zle-keymap-select () {
case $KEYMAP in
  vicmd) echo -ne '\e[1 q';; # block
  viins|main) echo -ne '\e[5 q';; # beam
esac
}
zle -N zle-keymap-select
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use vim keys in tab complete menu:
zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char
bindkey -M menuselect '^j' vi-down-line-or-history

eval "$(fasd --init auto)"
eval "$(fzf --zsh)"


# [[ HISTORY ]]
# HISTSIZE=1000
# SIZEHIST=1000000
# HISTFILE="$HOME"/.cache/foo
# setopt append_history
HISTFILE=~/.cache/zhistory
HISTSIZE=1000
SAVEHIST=100000
setopt inc_append_history hist_ignore_space



# # [[ PLUGINS ]]
# Load plugins.
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/lf/lf.zsh
source $XDG_DATA_HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $XDG_DATA_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh
source $XDG_DATA_HOME/powerlevel10k/powerlevel10k.zsh-theme
source $ZDOTDIR/.p10k.zsh

# [[ PROMPT ]]
# # PS1='%F{blue}%~ %(?.%F{green}.%F{blue})❯%f '
# eval "$(starship init zsh)"
# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
# typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet # Gets rid of error message when launching a nix shell
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
