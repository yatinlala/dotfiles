#!/bin/sh

userresources=$HOME/.config/X11/Xresources
usermodmap=$HOME/.config/X11/Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f $usermodmap ]; then
    xmodmap $usermodmap
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#Peripheral settings
xset b off
xinput --set-prop "SYNA8004:00 06CB:CD8B Touchpad" "libinput Natural Scrolling Enabled" 1
setxkbmap -option caps:swapescape -option altwin:swap_alt_win
#xset r rate 400 25 

#Env vars
export WM="i3-gaps"

exec i3
