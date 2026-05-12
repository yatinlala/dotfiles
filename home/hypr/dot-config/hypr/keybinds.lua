---------------------
---- KEYBINDINGS ----
---------------------

local mod = "SUPER"
local mod2 = "ALT"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mod .. "+ return", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. "+ SHIFT + return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mod .. "+ Q", hl.dsp.window.close())

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

-- CLIPBOARD
hl.bind(mod .. "+ apostrophe", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(mod .. "+ SHIFT + apostrophe", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist delete"))
hl.bind(mod .. " + " .. mod2 .. "+ apostrophe", hl.dsp.exec_cmd("cliphist wipe"))

hl.bind(mod .. "+ tab", hl.dsp.exec_cmd("swaync-client -t -sw"))

-- hl.bind(
-- 	mod .. "+ M",
-- 	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
-- )
hl.bind(mod .. " + f", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. "+ SHIFT + f", hl.dsp.window.fullscreen({ action = "toggle" }))

-- hl.bind(mod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mod .. "+ g", hl.dsp.group.toggle())

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
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

local function merge(t1, t2)
	for k, v in pairs(t2) do
		t1[k] = v
	end
	return t1
end

local function create_toggleable(opts)
	hl.window_rule(merge({
		match = { class = opts.class },
		float = true,
		size = "(monitor_w*" .. opts.width .. ") (monitor_h*" .. opts.height .. ")",
		center = true,
		workspace = "special:" .. opts.class,
	}, opts.windowrules or {}))

	hl.bind(opts.bind, function()
		local result = io.popen(opts.pgrep)
		local pid = result:read("*l")
		result:close()
		if not pid then
			hl.exec_cmd(opts.startup_cmd)
		end
		hl.dispatch(hl.dsp.workspace.toggle_special(opts.class))
	end)
end

create_toggleable({
	bind = mod .. " + M",
	class = "ferdium",
	width = 0.96,
	height = 0.9,
	pgrep = "pgrep -f ferdium",
	startup_cmd = "gtk-launch ferdium",
})

create_toggleable({
	bind = mod .. " + O",
	class = "obsidian",
	width = 0.96,
	height = 0.88,
	pgrep = "pgrep -f '/usr/lib/electron[0-9]*/electron /usr/lib/obsidian/app.asar'",
	startup_cmd = "gtk-launch obsidian",
	windowrules = { opacity = 0.98 },
})

create_toggleable({
	bind = mod .. " + S",
	class = "signal",
	width = 0.9,
	height = 0.9,
	pgrep = "pgrep -x signal-desktop",
	startup_cmd = "gtk-launch signal-desktop",
})

create_toggleable({
	bind = mod .. " + U",
	class = "Spotify",
	width = 0.8,
	height = 0.8,
	pgrep = "pgrep -x spotify",
	startup_cmd = "gtk-launch spotify-launcher",
})

hl.bind(mod .. " + d", hl.dsp.exec_cmd("handy --toggle-transcription"))

-- hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = "foot" })
-- Example special workspace (scratchpad)
-- hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- VOLUME  wpctl -l 1 to set max limit
hl.bind("SHIFT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("SHIFT + XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

-- ##### DISPLAY CONTROLS #####
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 1%-"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 1%+"), { locked = true, repeating = true })
hl.bind(mod .. "+ CTRL + 1", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind(mod .. "+ CTRL + 2", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind(mod .. " + " .. mod2 .. "+ j", hl.dsp.exec_cmd("gdark dec"), { locked = true, repeating = true })
hl.bind(mod .. " + " .. mod2 .. "+ k", hl.dsp.exec_cmd("gdark inc"), { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
--
-- bind = $mod,a,exec,toggler dpms
-- bind = $mod,backslash,exec,toggler inhibit-lid
-- bind = $mod shift,r,exec,toggler gammastep

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
