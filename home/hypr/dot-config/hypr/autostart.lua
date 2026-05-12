-- -------------------
-- ---- AUTOSTART ----
-- -------------------
-- {{{
-- -- See https://wiki.hypr.land/Configuring/Basics/Autostart/
--
hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- makes OBS work
	hl.exec_cmd("systemctl --user start hyprpolkitagent")

	hl.exec_cmd("swaync")
	hl.exec_cmd("waybar")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("handy --start-hidden")

	hl.exec_cmd("gammastep")
	hl.exec_cmd("syncthing --no-browser")

	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("wl-clip-persist --clipboard regular")

	hl.exec_cmd("pw-metadata -n settings 0 clock.quantum 256") -- TODO figure out persistent config change for this
	hl.exec_cmd("hyprshade on grayscale")
	hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 20%")

	hl.exec_cmd("swaybg --image ~/pictures/wallpapers/lone-tree.jpg")
	-- hl.exec_cmd("hyprctl setcursor Adwaita 24")

	-- exec-once=[workspace special:1 silent] ghostty
	-- exec-once=ghostty --class=org.yatin.workterm --working-directory=$HOME/software
	-- exec-once=hintsd
	-- exec-once=pypr
	-- exec-once=/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
	-- exec-once=~/.config/hypr/scripts/mindfulness-daemon

	-- $gnome-schema = org.gnome.desktop.interface
	-- exec-once=gsettings set $gnome-schema gtk-theme 'Gruvbox-Green-Dark-Compact'
	-- exec-once=gsettings set $gnome-schema gtk-theme 'Gruvbox-Material-Dark'
	-- exec-once=gsettings set $gnome-schema icon-theme 'Adwaita-dark'
	-- exec-once=gsettings set $gnome-schema icon-theme 'Gruvbox-Material-Dark'
	-- exec-once=gsettings set $gnome-schema cursor-theme 'Adwaita'
	-- exec-once=gsettings set $gnome-schema font-name 'Cantarell 14'
	-- exec=gsettings set org.gnome.desktop.interface cursor-size 24 THIS ONE
	-- exec=gsettings set org.gnome.desktop.interface text-scaling-factor $text_scale

	-- exec-once=snixembed --fork
	-- exec-once=sleep 5; safeeyes -e; sleep 5; pkill safeeyes; safeeyes -e

	-- exec-once=ianny
	-- exec-once=rclone mount dropbox:/org ~/documents/org
	-- exec-once=wluma
	-- exec-once = flatpak run com.github.wwmm.easyeffects --gapplication-service
end)
-- }}}
