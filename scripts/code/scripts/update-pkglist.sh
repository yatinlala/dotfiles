#!/bin/sh

pacman -Qqe | grep -v "$(pacman -Qqm)" > ~/.dotfiles/pkglist/pacman
pacman -Qqm > ~/.dotfiles/pkglist/pacman

# RESTORE
# cat pacman | xargs pacman -S --needed --noconfirm
