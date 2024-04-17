# [[ AUTOCOMPLETE ]]

# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -C
_comp_options+=(globdots)		# Include hidden files.


# # [[ SUPPLEMENTARY SCRIPTS ]]
# for config in "$ZDOTDIR"/scripts/*.zsh ; do
#     source "$config"
# done
# unset -v config


# [[ LOAD SHELL FUNCTIONS ]]
source "$ZDOTDIR/funcs.zsh"


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
zle-line-init() {
  zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
  echo -ne "\e[5 q"
}

zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# Use vim keys in tab complete menu:
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char
bindkey -M menuselect '^j' vi-down-line-or-history


# [[ BINDS ]]

### clear-screen-scrollback () {
###   echo -ne '\033c' # clear scrollback buffer as well
###   zle .clear-screen
### }
### 
### clear-screen-scrollback-insert () {
###   echo -ne '\033c' # clear scrollback buffer as well
###   zle .clear-screen
###   echo -ne "\e[6 q"
### }
### 
### zle -N clear-screen-scrollback
### zle -N clear-screen-scrollback-insert
### 
### # clear screen scrolleback keybindings
### bindkey -M main '^[k' clear-screen-scrollback
### bindkey -M viins '^[k' clear-screen-scrollback-insert
### bindkey -M vicmd '^[k' clear-screen-scrollback
### 
### bindkey -M main '^[l' clear-screen
### 
### # Change cursor shape for different vi modes.
### function zle-keymap-select () {
###     case $KEYMAP in
###         vicmd) echo -ne '\e[2 q';;      # block
###         viins|main) echo -ne '\e[6 q';; # beam
###     esac
### }
### zle -N zle-keymap-select
### zle-line-init() {
###     zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
###     echo -ne "\e[6 q"
### }
### zle -N zle-line-init
### 
### # Use lf to switch directories
### lf() {
###     tmp="$(mktemp)"
###     command lf -last-dir-path="$tmp" "$@"
###     if [ -f "$tmp" ]; then
###         dir="$(cat "$tmp")"
###         rm -f "$tmp" >/dev/null
###         [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
###     fi
### }
### 
### zle -N lf
### bindkey '^a' lf
### 
### # tmux-sessionizer() {
### #     $HOME/code/scripts/tmux-sessionizer
### # }
### 
### # zle -N tmux-sessionizer
### # bindkey '^f' tmux-sessionizer
### 
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

# bindkey '^R' history-incremental-pattern-search-backward

### 
### ff() {
###     files_list="$(fzf -m)"
###     return_code="$?"
### 
###     if [ "$return_code" -ne 0 ]; then
###         echo "Nothing to do; fzf return_code = $return_code"
###         return "$return_code"
###     fi
### 
###     echo "FILES SELECTED:"
###     echo "$files_list"
### 
###     # Convert the above list of newline-separated file names into an array
###     # - See: https://stackoverflow.com/a/24628676/4561887
###     SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
###     IFS=$'\n'      # Change IFS to newline char
###     files_array=($files_list) # split this newline-separated string into an array
###     IFS=$SAVEIFS   # Restore original IFS
### 
###     # Call vim with each member of the array as an argument
###     nvim "${files_array[@]}"
### }
### 
### 
### lark-toggle() {
###     lark toggle
### }
### zle -N lark-toggle
### bindkey '^y' lark-toggle
### 
### # Edit line in vim with ^e:
### autoload edit-command-line; zle -N edit-command-line
### bindkey -M vicmd '^e' edit-command-line

# [[ HISTORY ]]

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_CACHE_HOME"/history.zsh


# [[ OPTIONS ]]
setopt extendedglob nomatch interactive_comments
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


# [[ PLUGINS ]]

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


eval "$(fasd --init auto)"


# [[ PROMPT ]]
# PS1='%F{blue}%~ %(?.%F{green}.%F{blue})❯%f '
eval "$(starship init zsh)"
