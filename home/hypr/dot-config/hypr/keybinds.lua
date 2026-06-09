---------------------
---- KEYBINDINGS ----
---------------------
-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)

local mod = "SUPER"
local mod2 = "ALT"

local function bindexec(keys, cmd)
	local parts = {}

	for _, k in ipairs(keys) do
		table.insert(parts, tostring(k))
	end

	local keystr = table.concat(parts, " + ")
	hl.bind(keystr, hl.dsp.exec_cmd(cmd))
end

local function bindgeneric(keys, cmd)
	local parts = {}

	for _, k in ipairs(keys) do
		table.insert(parts, tostring(k))
	end

	local keystr = table.concat(parts, " + ")
	hl.bind(keystr, cmd)
end

bindexec({ mod, "Return" }, "kitty")
bindexec({ mod, "SHIFT", "Return" }, "ghostty")
bindgeneric({ mod, "Q" }, hl.dsp.window.close())

bindexec({ mod, "b" }, "gtk-launch zen")
bindexec({ mod, "SHIFT", "b" }, "gtk-launch brave-browser")

-- ROFI
bindexec({ mod, "space" }, "rofi -show drun")
bindexec({ mod, "SHIFT", "s" }, "~/.config/rofi/powermenu/powermenu.sh")
bindexec({ mod, "semicolon" }, "tessen -a both")
bindexec({ mod, "i" }, "rofimoji -a copy")
bindexec({ mod, "comma" }, "rofi-system-control")

-- CLIPBOARD
bindexec({ mod, "apostrophe" }, "cliphist list | rofi -dmenu | cliphist decode | wl-copy")
bindexec({ mod, "SHIFT", "apostrophe" }, "cliphist list | rofi -dmenu | cliphist delete")
bindexec({ mod, mod2, "apostrophe" }, "cliphist wipe")

-- NOTIFICATIONS
bindexec({ mod, "tab" }, "swaync-client -t -sw")

-- ##### SCREENSHOT #####
bindexec({ "Print" }, 'grim -g "$(slurp)" - | swappy -f -')
bindgeneric({ mod, "Print" }, hl.dsp.submap("hypr [O]CR [Q]R [C]OLOR_PICKER)"))
hl.define_submap("hypr [O]CR [Q]R [C]OLOR_PICKER)", function()
	hl.bind("o", function()
		hl.dispatch(hl.dsp.exec_cmd('grim -g "$(slurp)" - | tesseract stdin stdout | wl-copy'))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("q", function()
		hl.dispatch(hl.dsp.exec_cmd('grim -g "$(slurp)" - | qrtool decode | wl-copy'))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("c", function()
		hl.dispatch(hl.dsp.exec_cmd("wl-color-picker clipboard"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("escape", hl.dsp.submap("reset"))
end)

-- hl.bind(
-- 	mod .. "+ M",
-- 	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
-- )
bindgeneric({ mod, "f" }, hl.dsp.window.float({ action = "toggle" }))
bindgeneric({ mod, "SHIFT", "f" }, hl.dsp.window.fullscreen({ action = "toggle" }))

-- hl.bind(mod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
bindgeneric({ mod, "g" }, hl.dsp.group.toggle())

local function smart_focus(dir)
	local w = hl.get_active_window()
	if w == nil then
		return
	end

	local is_grouped = w.group ~= nil and w.group.size > 1

	if not is_grouped or dir == "up" or dir == "down" then
		hl.dispatch(hl.dsp.focus({ direction = dir }))
		return
	end

	if dir == "right" then
		if w.group.current_index == w.group.size then
			hl.dispatch(hl.dsp.focus({ direction = "right" }))
		else
			hl.dispatch(hl.dsp.group.next())
		end
	elseif dir == "left" then
		if w.group.current_index == 1 then
			hl.dispatch(hl.dsp.focus({ direction = "left" }))
		else
			hl.dispatch(hl.dsp.group.prev())
		end
	end
end

bindgeneric({ mod, "h" }, function()
	smart_focus("left")
end)
bindgeneric({ mod, "j" }, function()
	smart_focus("down")
end)
bindgeneric({ mod, "k" }, function()
	smart_focus("up")
end)
bindgeneric({ mod, "l" }, function()
	smart_focus("right")
end)

-- TODO fix this
local function smart_move(dir)
	local w = hl.get_active_window()
	if w == nil then
		return
	end

	local is_grouped = w.group ~= nil

	if not is_grouped or dir == "up" or dir == "down" then
		hl.dispatch(hl.dsp.window.move({ direction = dir }))
		return
	end

	if dir == "right" then
		if w.group.current_index == w.group.size then
			hl.dispatch(hl.dsp.window.move({ out_of_group = "right" }))
		else
			hl.dispatch(hl.dsp.group.move_window({ forward = true }))
		end
	elseif dir == "left" then
		if w.group.current_index == 1 then
			hl.dispatch(hl.dsp.window.move({ out_of_group = "left" }))
		else
			-- NOT SETTING forward = true moves backward.
			-- imo a pretty rough API. maybe should file
			-- a gh discussion. ok now you need forward = false?
			hl.dispatch(hl.dsp.group.move_window({ forward = false }))
		end
	end
end

bindgeneric({ mod, "SHIFT", "H" }, function()
	smart_move("left")
end)
bindgeneric({ mod, "SHIFT", "J" }, function()
	smart_move("down")
end)
bindgeneric({ mod, "SHIFT", "K" }, function()
	smart_move("up")
end)
bindgeneric({ mod, "SHIFT", "L" }, function()
	smart_move("right")
end)

hl.bind(mod2 .. "+ SHIFT + h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mod2 .. "+ SHIFT + j", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
hl.bind(mod2 .. "+ SHIFT + k", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mod2 .. "+ SHIFT + l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })

bindgeneric({ mod, "z" }, hl.dsp.focus({ workspace = "e-1" }))
bindgeneric({ mod, "x" }, hl.dsp.focus({ workspace = "e+1" }))
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

bindexec({ mod, "d" }, "handy --toggle-transcription")
bindexec({ mod, "v" }, "kitty --app-id org.yatin.fzfpopup -e fuzzy_video")
bindexec({ mod, "SHIFT", "m" }, "gtk-launch mpv")

-- ##### GAMES #####
bindgeneric({ mod, "SHIFT", "g" }, hl.dsp.submap("game [l]ichess [m]inecraft [s]team"))
hl.define_submap("game [l]ichess [m]inecraft [s]team", function()
	-- # # bind = ,t,exec,$term -e netris -k "hHklLJjs frn" -i .15
	hl.bind("l", function()
		hl.exec_cmd("gtk-launch brave-pdihgkikjgccndbckbcgjmcnpkockcjg-Default")
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("m", function()
		hl.exec_cmd("gtk-launch com.atlauncher.ATLauncher")
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("s", function()
		hl.exec_cmd("gtk-launch steam")
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.bind(mod .. " + r", hl.dsp.submap("hypr [g]ray [i]nvert [k]ill [p]erf [r]eload [s]wallow [w]aybar)"))

local shaders = require("shaders")
hl.define_submap("hypr [g]ray [i]nvert [k]ill [p]erf [r]eload [s]wallow [w]aybar)", function()
	hl.bind("g", function()
		shaders.toggle("grayscale.glsl")
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("i", function()
		shaders.toggle("invert-colors.glsl")
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("k", function()
		hl.dispatch(hl.dsp.exec_cmd("hyprctl kill"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	-- bind=  ,p,exec,~/.config/hypr/scripts/perf
	-- hl.bind("p", function()
	-- 	hl.notification.create({ text = "we here", duration = 2000 })
	-- 	hl.dispatch(hl.dsp.submap("reset"))
	-- end)
	hl.bind("r", function()
		hl.dispatch(hl.dsp.exec_cmd("hyprctl reload && killall waybar && exec waybar"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("s", function()
		hl.dispatch(hl.dsp.window.toggle_swallow())
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("w", function()
		hl.dispatch(hl.dsp.exec_cmd("killall waybar && exec waybar"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.bind(mod .. " + " .. mod2 .. " + B", hl.dsp.exec_cmd("kitty --app-id org.yatin.fzfpopup -e bluetui"))

-- ### TABBER ###
bindgeneric({ mod, "t" }, hl.dsp.submap("tabber(efsd)"))
hl.define_submap("tabber(efsd)", function()
	hl.bind("e", function()
		hl.dispatch(hl.dsp.exec_cmd("tabber edit"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("f", function()
		hl.dispatch(hl.dsp.exec_cmd("tabber find"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("s", function()
		hl.dispatch(hl.dsp.exec_cmd("tabber store"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("d", function()
		hl.dispatch(hl.dsp.exec_cmd("tabber delete"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)

	hl.bind("escape", hl.dsp.submap("reset"))
end)

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
bindexec({ mod, "SHIFT", "v" }, "pavucontrol")

-- ##### DISPLAY CONTROLS #####
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 1%-"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 1%+"), { locked = true, repeating = true })
hl.bind(mod .. "+ CTRL + 1", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind(mod .. "+ CTRL + 2", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind(mod .. " + " .. mod2 .. "+ j", hl.dsp.exec_cmd("gdark dec"), { locked = true, repeating = true })
hl.bind(mod .. " + " .. mod2 .. "+ k", hl.dsp.exec_cmd("gdark inc"), { locked = true, repeating = true })
hl.bind(mod .. " + a", hl.dsp.dpms("toggle"))
-- hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
--
-- bind = $mod,backslash,exec,toggler inhibit-lid
-- bind = $mod shift,r,exec,toggler gammastep

hl.bind(mod .. "+ bracketleft", hl.dsp.exec_cmd("playerctl --player=spotify,mpd,spotifyd,mpv previous"), { locked = true })
hl.bind(mod .. "+ bracketright", hl.dsp.exec_cmd("playerctl --player=spotify,mpd,spotifyd,mpv next"), { locked = true })
hl.bind("XF86Favorites", hl.dsp.exec_cmd("playerctl --player=spotify,mpd,spotifyd,mpv play-pause"), { locked = true })

-- hl.notification.create({ text = "we here", duration = 2000 })
