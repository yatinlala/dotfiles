typeset -U PATH path

export PATH="$HOME/.local/share/npm/bin:$HOME/.local/bin:$HOME/.local/share/go/bin:$HOME/.local/scripts:$HOME/.local/share/cargo/bin:$PATH"

# XDG paths
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_SCREENSHOTS_DIR="$HOME/pictures/screenshots"

# https://nixos.wiki/wiki/Locales
export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive


SCRIPTS="$HOME/.local/scripts"
# FZF
export FZF_DEFAULT_OPTS="--cycle --scroll-off=0 --walker-skip=.git,node_modules,.cache,.local/share/go/pkg,.local/share/Zeal,.local/share/pipx/venvs,.local/xdg-launch,.local/share/Steam,.config/vivaldi,.config/Cursor"
export FZF_ALT_C_OPTS="--walker=dir,hidden,follow"
export FZF_CTRL_T_OPTS="--walker=file,hidden,follow,dir"
# export FZF_DEFAULT_COMMAND='fd -H .'

export GRIM_DEFAULT_DIR="$XDG_SCREENSHOTS_DIR"

export SUDO_ASKPASS="$SCRIPTS/rofi-askpass"

export CALIBRE_USE_DARK_PALETTE=1
export DIFFPROG="nvim -d"

# export GTK_THEME='Gruvbox-Dark'
# export GTK2_RC_FILES=$XDG_DATA_HOME/themes/Gruvbox-Dark/gtk-2.0/gtkrc
export QT_STYLE_OVERRIDE=Adwaita-Dark

# Fixing Paths
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export STACK_ROOT="$XDG_DATA_HOME"/stack
export MBSYNCRC="$XDG_CONFIG_HOME/mbsyncrc"
export CONAN_USER_HOME="$XDG_CONFIG_HOME/conan/"
export TASKRC="$XDG_CONFIG_HOME/task/taskrc"
export SQLITE_HISTORY=$XDG_DATA_HOME/sqlite_history
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
export OLLAMA_MODELS="$XDG_DATA_HOME/ollama"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
#export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export GOPATH="$XDG_DATA_HOME"/go
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export VSCODE_PORTABLE="$XDG_DATA_HOME"/vscode
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export NLTK_DATA="$XDG_DATA_HOME"/nltk

# Default Apps
export EDITOR="nvim"
export READER="zathura"
export VISUAL="nvim"
export BROWSER="gtk-launch zen"
export TERMINAL="kitty -1"
export VIDEO="mpv"
export IMAGE="imv"
export COLORTERM="truecolor"
export OPENER="xdg-open"
export PAGER="less --quit-if-one-screen --ignore-case --raw-control-chars --chop-long-lines"


export ZDOTDIR="$HOME/.config/zsh" 

# Configure zsh_autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HISTORY_IGNORE="newsboat|pipe-viewer"


# export MANWIDTH=60 # resizing window will work! nvim handles wrap
# export MANPAGER='nvim +Man!'
# Colored man pages
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# export MANROFFOPT="-c" # Fix formatting errors

# Get LF icons to work
export LC_ALL="en_US.UTF-8"

# SWAY WAYLAND STUFF
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NOREPARENTING=1
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export GDK_BACKEND="wayland,x11"
export MOZ_ENABLE_WAYLAND=1

# source ~/.config/zsh/.secret.env # I moved this to $ZDOTDIR/scripts
