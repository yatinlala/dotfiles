if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep Hyprland || exec Hyprland

	# read -n1 ans
	#
	# if [[ "$ans" == "h" ]]; then
	# 	exec Hyprland
	# elif [[ "$ans" == "c" ]]; then
	# 	exec start-cosmic
	# else
	#   echo "Invalid input"
	# fi
fi