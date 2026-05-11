-- ------------------
-- ---- MONITORS ----
-- ------------------
-- {{{
-- -- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})
-- # mirror monitor
-- # monitor=HDMI-A-1,1920x1080@60,0x0,1,mirror,eDP-1
--
-- # disable laptop screen
-- # monitor=,highres,auto,1
-- # monitor=eDP-1,disable
--
-- # use nwg-displays generated conf
-- # source=~/.config/hypr/monitors.conf
-- }}}

-- -------------------
-- ---- AUTOSTART ----
-- -------------------
-- {{{
-- -- See https://wiki.hypr.land/Configuring/Basics/Autostart/
--
hl.on("hyprland.start", function()
	-- exec-once=[workspace special:1 silent] ghostty
	-- exec-once=ghostty --class=org.yatin.workterm --working-directory=$HOME/software
	-- exec-once=hintsd
	-- exec-once=pypr
	-- exec-once=/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
	-- exec-once=~/.config/hypr/scripts/mindfulness-daemon

	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- makes OBS work
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("syncthing --no-browser")
	hl.exec_cmd("handy --start-hidden")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("pw-metadata -n settings 0 clock.quantum 256") -- TODO figure out persistent config change for this
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("wl-clip-persist --clipboard regular")
	hl.exec_cmd("swaync")
	hl.exec_cmd("waybar")
	hl.exec_cmd("gammastep")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("hyprshade on grayscale")
	hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 20%")

	--  THEMING
	hl.exec_cmd("swaybg --image ~/pictures/wallpapers/lone-tree.jpg")
	-- hl.exec_cmd("hyprctl setcursor Adwaita 24")

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

require("environment")

-----------------------
----- PERMISSIONS -----
-----------------------
-- {{{
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
-- }}}

-----------------------
---- LOOK AND FEEL ----
-----------------------
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 2,
		border_size = 4,

		-- col.active_border = rgba(fabd2fee) rgba(83a598ee) 270deg
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "master",
	},

	decoration = {
		rounding = 8,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = false,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = false,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		new_status = "master",
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		repeat_delay = 350,
		repeat_rate = 38,

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
			tap_to_click = false,
		},

		focus_on_close = true, -- fixes swallow focus change
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mod .. " + return", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + Q", hl.dsp.window.close())

-- local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)

hl.bind(mod .. "+ b", hl.dsp.exec_cmd("gtk-launch zen"))
hl.bind(mod .. "+ SHIFT + b", hl.dsp.exec_cmd("gtk-launch brave-browser"))

-- ROFI
hl.bind(mod .. "+ space", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mod .. "+ SHIFT + s", hl.dsp.exec_cmd("~/.config/rofi/powermenu/powermenu.sh"))
hl.bind(mod .. "+ semicolon", hl.dsp.exec_cmd("tessen -a both"))
hl.bind(mod .. "+ i", hl.dsp.exec_cmd("rofimoji -a copy"))
hl.bind(mod .. "+ comma", hl.dsp.exec_cmd("rofi-system-control"))

-- hl.bind(
-- 	mod .. "+ M",
-- 	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
-- )
-- hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
-- hl.bind(mod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(mod .. "+ h", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. "+ l", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. "+ k", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. "+ j", hl.dsp.focus({ direction = "down" }))

hl.bind(mod .. "+ SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. "+ SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. "+ SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. "+ SHIFT + j", hl.dsp.window.move({ direction = "down" }))

hl.bind(mod .. "+ z", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. "+ x", hl.dsp.focus({ workspace = "e+1" }))
-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
-- hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- vim:foldmethod=marker:foldlevel=0
