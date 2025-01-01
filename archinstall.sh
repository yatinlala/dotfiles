#!/usr/bin/bash
set -eu

cd "$HOME"

# INSTALL PARU
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

cd "$HOME"

sudo pacman -S pacman-contrib
sudo systemctl enable --now paccache.timer

# I THINK THIS IS REDUNDANT W/ BTRFS /etc/fstab discard=async
# sudo systemctl enable fstrim.timer

### PACKAGES ###

sudo pacman -S waybar hyprland rofi-wayland rofimoji

sudo pacman -S ghostty
