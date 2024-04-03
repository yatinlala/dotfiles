###  # TODO convert aliases to shell commands 
###  # https://blog.sanctum.geek.nz/custom-commands/

#XDG Compliance
flatpak() { xdg-launch flatpak "$@" }
yt-dlp() { xdg-launch yt-dlp "$@" }
###  alias audacity='xdg-launch audacity'
###  # alias ollama='xdg-launch ollama'
###  alias spotdl='xdg-launch spotdl'
###  alias code='xdg-launch code'
###  alias firefox='xdg-launch firefox'
###  alias jupyter='xdg-launch jupyter'
###  alias librewolf='xdg-launch librewolf'
###  alias minecraft-launcher='xdg-launch minecraft-launcher'
###  alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
###  # alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

# [[ IMPROVE DEFAULTS ]]
# alias df='df -h'
# alias cat='bat -pp'
# alias free='free -m'
# alias info='info --vi-keys'
# alias bc='bc -lq'
# alias tetris='netris -k "hHklLJjs frn" -i .1'
# alias grep='grep --color=auto --exclude-dir=.git -I'
# alias egrep='grep -E'
# alias fgrep='grep -F'
ls() { eza --icons "$@" }

# [[ SHORTEN FREQUENTS ]]
e() { $EDITOR "$@" }
wmc() { $EDITOR ~/.config/hypr/hyprland.conf }
mmute() { echo 0 | sudo tee /sys/class/leds/platform::micmute/brightness }
lg() { lazygit "$@" }
ll() { ls -l "$@" }
la() { ll -a "$@" }
ed() { sudo systemctl start docker }
wiki() { nvim ~/documents/org/main.org }
###  alias '?'='duck'


###  alias musb='sudo mount /dev/sda1 ~/.local/usb'
###  alias uusb='sudo umount ~/.local/usb'
###  alias domains="sudo tcpdump -l port 53 2>/dev/null | grep --line-buffered ' A? ' | cut -d' ' -f8"
###  alias orphans='pacman -Qtdq'
###  alias myip='curl -4 https://icanhazip.com'
###  alias reflector="sudo reflector -f 30 -l 30 --verbose --save /etc/pacman.d/mirrorlist"
###  alias tpv='command mpv --vo=tct'
batreport() { upower -i /org/freedesktop/UPower/devices/battery_BAT0 }

###  alias ask='yai -e'
###  alias aske='shell-genie --explain ask'

###  alias jupl='source $HOME/.local/venv/jupl/bin/activate'

update-pkglist() {
    pacman -Qqne > ~/.dotfiles/pkglist/pacman
    pacman -Qqm > ~/.dotfiles/pkglist/aur
    cargo install --list > ~/.dotfiles/pkglist/cargo
    npm -g list > ~/.dotfiles/pkglist/npm
    pip3 list > ~/.dotfiles/pkglist/pip3
    pipx list > ~/.dotfiles/pkglist/pipx
    flatpak list --app > ~/.dotfiles/pkglist/flatpak
}

###  stable-diffusion() {
    ###  cd ~/code/stable-diffusion-webui/
    ###  export PYTORCH_TRACING_MODE=TORCHFX
    ###  export COMMANDLINE_ARGS="--skip-torch-cuda-test --precision full --no-half" 
    ###  source sd_env/bin/activate
    ###  ./webui.sh
###  }


###  #Devouring
###  # alias feh='swallow feh --scale-down'
###  # alias mpv='swallow mpv'

###  #Git
###  alias gs='git status'
###  alias gl='git log'
###  alias ga='git add'
###  alias gc='git commit'
###  alias gch='git checkout'
###  alias gr='git restore'
###  alias gd='git diff'
###  alias gp='git push'

###  #Docker
###  alias dl='docker logs --follow --timestamps'
###  
###  #rmtrash
###  alias rm='rmtrash -I'
###  alias rmdir='rmdirtrash'

###  # #Confirm before danger
###  # alias rm='rm -I'

#Media
yt() { yt-dlp --embed-chapters --embed-metadata --embed-subs --sub-langs 'en.*' "$@" }
yta() { yt-dlp --extract-audio "$@" }
ytp() { yt -o '%(playlist_index)2d - %(title)s.%(ext)s' -i "$@" }
###  alias ffmp3="ffmpeg -i '${FILE}' -vn -ab 128k -ar 44100 -y '${FILE%.webm}.mp3'"
###  alias \newsboat="~/.local/scripts/newsboat"
###  alias /usr/bin/newsboat='echo no'
###  alias \\/usr/bin/newsboat='echo no'

