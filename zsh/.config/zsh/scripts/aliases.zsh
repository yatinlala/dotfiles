# TODO convert aliases to shell commands 
# https://blog.sanctum.geek.nz/custom-commands/

#Improve Defaults
alias df='df -h'
alias cat='bat -pp'
alias free='free -m'
alias info='info --vi-keys'
alias bc='bc -lq'
alias tetris='netris -k "hHklLJjs frn" -i .1'
alias grep='grep --color=auto --exclude-dir=.git -I'
alias egrep='grep -E'
alias fgrep='grep -F'
alias ls='eza --icons'

#Shorten frequently used commands
alias e='$EDITOR'
# alias emacs='emacsclient -nw'
alias ed='sudo systemctl start docker'
alias t='tmux'
alias lg='lazygit'
alias la='ls -ah'
alias ll='ls -lh'
alias lal='ls -lah'
alias ka='killall'
alias p='pacman'
alias sp='sudo pacman'
alias '?'='duck'


alias jupl='source $HOME/.local/venv/jupl/bin/activate'

update-pkglist() {
    pacman -Qqne > ~/.dotfiles/pkglist/pacman
    pacman -Qqm > ~/.dotfiles/pkglist/aur
    cargo install --list > ~/.dotfiles/pkglist/cargo
    npm -g list > ~/.dotfiles/pkglist/npm
    pip3 list > ~/.dotfiles/pkglist/pip3
    pipx list > ~/.dotfiles/pkglist/pipx
    flatpak list --app > ~/.dotfiles/pkglist/flatpak
}

stable-diffusion() {
    cd ~/code/stable-diffusion-webui/
    export PYTORCH_TRACING_MODE=TORCHFX
    export COMMANDLINE_ARGS="--skip-torch-cuda-test --precision full --no-half" 
    source sd_env/bin/activate
    ./webui.sh
}

alias mmute='echo 0 | sudo tee /sys/class/leds/platform::micmute/brightness'
alias musb='sudo mount /dev/sda1 ~/.local/usb'
alias uusb='sudo umount ~/.local/usb'
alias wallpaper='feh --bg-fill --no-fehbg --recursive --randomize ~/pictures/wallpapers'
alias domains="sudo tcpdump -l port 53 2>/dev/null | grep --line-buffered ' A? ' | cut -d' ' -f8"
alias orphans='pacman -Qtdq'
alias xevsym="xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'"
alias myip='curl -4 https://icanhazip.com'
alias reflector="sudo reflector -f 30 -l 30 --verbose --save /etc/pacman.d/mirrorlist"
alias tpv='command mpv --vo=tct'
alias batreport='upower -i /org/freedesktop/UPower/devices/battery_BAT0'

#Devouring
# alias feh='swallow feh --scale-down'
# alias mpv='swallow mpv'

#Git
alias gs='git status'
alias gl='git log'
alias ga='git add'
alias gc='git commit'
alias gch='git checkout'
alias gr='git restore'
alias gd='git diff'
alias gp='git push'

#Docker
alias dl='nocker logs --follow --timestamps'

#rmtrash
alias rm='rmtrash -I'
alias rmdir='rmdirtrash'

# #Confirm before danger
# alias rm='rm -I'

#File Jumps
alias wmc='$EDITOR ~/.config/hypr/hyprland.conf'
alias wiki='emacs -nw ~/documents/org/main.org'

#Media
alias yt-dlp="xdg-launch yt-dlp"
alias youtube-dl="xdg-launch youtube-dl"
alias yt="yt-dlp --embed-chapters --embed-metadata --embed-subs --sub-langs 'en.*'"
alias yta='yt-dlp -audio-format opus --extract-audio'
alias ytp="yt -o '%(playlist_index)2d - %(title)s.%(ext)s' -i"
alias ffmp3="ffmpeg -i '${FILE}' -vn -ab 128k -ar 44100 -y '${FILE%.webm}.mp3'"
alias newsboat="~/.local/scripts/newsboat"
alias \newsboat="~/.local/scripts/newsboat"
alias /usr/bin/newsboat='echo no'
alias \\/usr/bin/newsboat='echo no'

#XDG Compliance
alias audacity='xdg-launch audacity'
# alias ollama='xdg-launch ollama'
alias spotdl='xdg-launch spotdl'
alias code='xdg-launch code'
alias firefox='xdg-launch firefox'
alias jupyter='xdg-launch jupyter'
alias flatpak='xdg-launch flatpak'
alias librewolf='xdg-launch librewolf'
alias minecraft-launcher='xdg-launch minecraft-launcher'
alias w3m='xdg-launch w3m'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
# alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

#Aliases work after command
alias sudo='sudo '
alias devour='devour '

# FASD
# alias a='fasd -a'        # any
# alias s='fasd -si'       # show / search / select
# alias d='fasd -d'        # directory
# alias f='fasd -f'        # file
# alias sd='fasd -sid'     # interactive directory selection
# alias sf='fasd -sif'     # interactive file selection
# alias z='fasd_cd -d'     # cd, same functionality as j in autojump
# alias zz='fasd_cd -d -i' # cd with interactive selection


# alias 'git pull'="echo '\'git: \'pull\' is not a git command. See \'git --help\'.
#
# The most similar command is
# 	tug'"
