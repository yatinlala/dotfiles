# [[ BINDS ]]
# clear-screen-scrollback () {
#   echo -ne '\033c' # clear scrollback buffer as well
#   zle .clear-screen
# }
#
# clear-screen-scrollback-insert () {
#   echo -ne '\033c' # clear scrollback buffer as well
#   zle .clear-screen
#   echo -ne "\e[6 q"
# }
#
# zle -N clear-screen-scrollback
# zle -N clear-screen-scrollback-insert
#
# # clear screen scrolleback keybindings
# bindkey -M main '^[k' clear-screen-scrollback
# bindkey -M viins '^[k' clear-screen-scrollback-insert
# bindkey -M vicmd '^[k' clear-screen-scrollback
#
# bindkey -M main '^[l' clear-screen

# # Use lf to switch directories
# lf() {
#     tmp="$(mktemp)"
#     command lf -last-dir-path="$tmp" "$@"
#     if [ -f "$tmp" ]; then
#         dir="$(cat "$tmp")"
#         rm -f "$tmp" >/dev/null
#         [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
#     fi
# }
#
# zle -N lf
# bindkey '^a' lf
#
# tmux-sessionizer() {
#     $HOME/code/scripts/tmux-sessionizer
# }

# zle -N tmux-sessionizer
# bindkey '^f' tmux-sessionizer

# 
# ff() {
#     files_list="$(fzf -m)"
#     return_code="$?"
# 
#     if [ "$return_code" -ne 0 ]; then
#         echo "Nothing to do; fzf return_code = $return_code"
#         return "$return_code"
#     fi
# 
#     echo "FILES SELECTED:"
#     echo "$files_list"
# 
#     # Convert the above list of newline-separated file names into an array
#     # - See: https://stackoverflow.com/a/24628676/4561887
#     SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
#     IFS=$'\n'      # Change IFS to newline char
#     files_array=($files_list) # split this newline-separated string into an array
#     IFS=$SAVEIFS   # Restore original IFS
# 
#     # Call vim with each member of the array as an argument
#     nvim "${files_array[@]}"
# }
# 
# 
# lark-toggle() {
#     lark toggle
# }
# zle -N lark-toggle
# bindkey '^y' lark-toggle
# 
# Edit line in vim with ^e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
# bindkey -M vicmd '^e' edit-command-line
