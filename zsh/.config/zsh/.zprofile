if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep i3  || $HOME/code/scripts/startx.sh
fi
