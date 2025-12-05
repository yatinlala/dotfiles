# TODO convert aliases to shell commands 
# https://blog.sanctum.geek.nz/custom-commands/

# [[ XDG COMPLIANCE ]]
# alias flatpak='xdg-launch flatpak'
# alias audacity='xdg-launch audacity'
alias ollama='xdg-launch ollama'
alias spotdl='xdg-launch spotdl'
alias scrcpy='xdg-launch scrcpy'
alias claude='xdg-launch claude'
alias codex='xdg-launch codex'
alias lk='xdg-launch lk'
dosbox() { dosbox -conf "$XDG_CONFIG_HOME"/dosbox/dosbox.conf "$@" }
# alias code='xdg-launch code'
alias cursor='xdg-launch cursor'
# alias firefox='xdg-launch firefox'
# alias jupyter='xdg-launch jupyter'
# alias librewolf='xdg-launch librewolf'
# alias minecraft-launcher='xdg-launch minecraft-launcher'
wget() { command wget --hsts-file="$XDG_CACHE_HOME/wget-hsts" "$@" }
# alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

# [[ IMPROVE DEFAULTS ]]
# alias df='df -h'
# alias cat='bat -pp'
alias gemini='xdg-launch gemini'
alias info='info --vi-keys'
alias bc='bc -lq'
# alias ls='ls --color=auto'
alias nix-shell='nix-shell --command zsh'
nix() {
  if [[ "$1" == "develop" ]]; then
    shift  # Remove 'develop' from the arguments
    command nix develop --command zsh "$@"
  else
    command nix "$@"
  fi
}
# alias tetris='netris -k "hHklLJjs frn" -i .1'
# alias grep='grep --color=auto --exclude-dir=.git -I'
# alias egrep='grep -E'
if command -v eza > /dev/null; then
  ls() { eza --icons=auto "$@" }
else
  alias ls='ls --color=auto'
fi
ll() { ls -l "$@" }
la() { ll -a "$@" }
vis() { $EDITOR -S Session.vim }
wmc() { $EDITOR ~/.config/hypr/hyprland.conf }
mmute() { echo 0 | sudo tee /sys/class/leds/platform::micmute/brightness }
# ll() { ls -lh "$@" }
# la() { ll -A "$@" }
ed() { sudo systemctl start docker }
alias '?'='duck'

# [[ SHORTEN FREQUENTS ]]
e() { $EDITOR "$@" }
lg() { lazygit "$@" }
git-clean() {
  git clean -xfd
  git reset --hard
}
fe() { print -z "$(functions $@ | sed '1d;$d' | sed 's/^[[:space:]]*//')"}
ccd() { clang -std=c99 -g -O0 -Wall -Wextra -fsanitize=undefined,address "$@" }
ccr() { clang -std=c99 -O3 "$@" }


# [[ NOVELTY ]]
domains() { sudo tcpdump -l port 53 2>/dev/null | grep --line-buffered ' A? ' | cut -d' ' -f8 }
orphans() { pacman -Qtdq }
myip() { curl -4 https://icanhazip.com }
# alias reflector="sudo reflector -f 30 -l 30 --verbose --save /etc/pacman.d/mirrorlist"
tpv() { command mpv --vo=tct "$@" }

###  alias ask='yai -e'
###  alias aske='shell-genie --explain ask'

###  alias jupl='source $HOME/.local/venv/jupl/bin/activate'

update-pkglist() {
    pacman -Qqne > ~/.dotfiles/pkglist/pacman
    pacman -Qqm > ~/.dotfiles/pkglist/aur
    cargo install --list > ~/.dotfiles/pkglist/cargo
    npm -g list > ~/.dotfiles/pkglist/npm
    # pip3 list > ~/.dotfiles/pkglist/pip3
    pipx list > ~/.dotfiles/pkglist/pipx
    flatpak list --app > ~/.dotfiles/pkglist/flatpak
}

 stable-diffusion() {
     cd ~/code/stable-diffusion/stable-diffusion-webui/
     export PYTORCH_TRACING_MODE=TORCHFX
     export COMMANDLINE_ARGS="--skip-torch-cuda-test --precision full --no-half" 
     source .venv/bin/activate
 }


#Docker
alias dl='docker logs --follow --timestamps'

#rmtrash
# alias rm='rmtrash -I'
# alias rmdir='rmdirtrash'

#Confirm before danger
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'

#Media
yt() { xdg-launch yt-dlp -f "bv*[height<=1080]+ba" --embed-chapters --embed-metadata --embed-subs --sub-langs 'en.*' "$@" }
ytl() { xdg-launch yt-dlp -f "bv*[height<=720]+ba" --embed-chapters --embed-metadata --embed-subs --sub-langs 'en.*' "$@" }
alias ytl="xdg-launch yt-dlp -f \"bv*[height<=720]+ba\" --embed-chapters --embed-metadata --embed-subs --sub-langs 'en.*'"
yta() { xdg-launch yt-dlp --extract-audio "$@" }
ytp() { yt -o '%(playlist_index)2d - %(title)s.%(ext)s' -i "$@" }
ytd() { yt -o '~/videos/📒 %(title)s.%(ext)s' "$@" }
# alias ffmp3="ffmpeg -i '${FILE}' -vn -ab 128k -ar 44100 -y '${FILE%.webm}.mp3'"
# alias \newsboat="~/.local/scripts/newsboat"
# alias /usr/bin/newsboat='echo no'
# alias \\/usr/bin/newsboat='echo no'
