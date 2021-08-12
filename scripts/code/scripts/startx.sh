#!/usr/bin/bash -e

echo "Enter 'a' for awesomewm or 'i' for i3wm"

read input

if [ $input = "a" ] 
then
    startx "$HOME/.config/X11/xinitrc.awesome"
elif [ $input = "i" ] 
then
    startx "$HOME/.config/X11/xinitrc.i3"
fi
