typeset -U PATH path

export PATH="$HOME/.local/bin:$HOME/code/scripts/toggles:$HOME/.local/share/go/bin:$HOME/code/scripts/launch-wrappers:$HOME/code/scripts:$HOME/.local/share/cargo/bin:$HOME/.local/share/applications:$PATH"


export SCRIPT_PATH="$HOME/code/scripts"
# FZF
export FZF_DEFAULT_OPTS='--cycle'
export FZF_DEFAULT_COMMAND='fd -H .'

# Cursor
# export XCURSOR_PATH=${XCURSOR_PATH}:~/.local/share/icons
# export XCURSOR_THEME=Breeze_Snow

#QT Styling
QT_QPA_PLATFORMTHEME='qt5ct'

# XDG paths
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_JUNK_DIR="$HOME/.local/xdg-garbage"
export XDG_SCREENSHOTS_DIR="$HOME/pictures/screenshots"

export CALIBRE_USE_DARK_PALETTE=1
#export GTK_THEME='Adwaita:dark'
export DIFFPROG="nvim -d"
export SXHKD_SHELL="sh"

# Fixing Paths
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export STACK_ROOT="$XDG_DATA_HOME"/stack
export MBSYNCRC="$XDG_CONFIG_HOME/mbsyncrc"
export CONAN_USER_HOME="$XDG_CONFIG_HOME/conan/"
export DOOMDIR="$XDG_CONFIG_HOME/doom"
export TASKRC="$XDG_CONFIG_HOME/task/taskrc"
export SQLITE_HISTORY=$XDG_DATA_HOME/sqlite_history
export ZSH_CUSTOM="$XDG_CONFIG_HOME/zsh"
export SSB_HOME="$XDG_DATA_HOME/zoom"
export GEM_PATH="$XDG_DATA_HOME/ruby/gems"
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export GEM_SPEC_CACHE="$XDG_DATA_HOME/ruby/specs"
export GEM_HOME="$XDG_DATA_HOME/ruby/gems"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export RANDFILE='$XDG_RUNTIME_DIR/rnd'
export CCACHE_CONFIGPATH="$XDG_CONFIG_HOME"/ccache.config
export CCACHE_DIR="$XDG_CACHE_HOME"/ccache
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NVM_DIR="$XDG_DATA_HOME"/nvm
export MPLAYER_HOME="$XDG_CONFIG_HOME"/mplayer
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/config"
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export OPAMROOT="$XDG_DATA_HOME/opam"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
#export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export GOPATH="$XDG_DATA_HOME"/go
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export ZDOTDIR="$HOME/.config/zsh" 
export RXVT_SOCKET="$XDG_RUNTIME_DIR/urxvtd"
export VSCODE_PORTABLE="$XDG_DATA_HOME"/vscode
export HISTFILE="$XDG_DATA_HOME"/zsh/history
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export NLTK_DATA="$XDG_DATA_HOME"/nltk
# Default Apps
export EDITOR="nvim"
export READER="zathura"
export VISUAL="nvim"
export BROWSER="xdg-launch vivaldi-stable"
export TERMINAL="kitty -1"
export VIDEO="mpv"
export IMAGE="imv"
export COLORTERM="truecolor"
export OPENER="xdg-open"
export PAGER="bat --paging=always"

# Disable less history files 
export LESSHISTFILE=-

# Colored man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c" # Fix formatting errors

# Get LF icons to work
export LC_ALL="en_US.UTF-8"

# SWAY WAYLAND STUFF
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NOREPARENTING=1
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export GDK_BACKEND="wayland,x11"
export MOZ_ENABLE_WAYLAND=1

source ~/.config/zsh/.secret.env

if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep Hyprland || Hyprland
	# pgrep sway || sway
fi
