-- ------------------
-- ---- MONITORS ----
-- ------------------
-- {{{
-- -- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

local laptop_screen_name = "eDP-1"
-- local scratchpads = require("scratchpads")
--
-- local function refresh_delayed()
-- 	hl.timer(scratchpads.refresh_geometries, { timeout = 600, type = "oneshot" })
-- end
--
-- -- hl.on("monitor.added", function(m)
-- -- 	if m.name ~= laptop_screen_name then
-- -- 		hl.timer(function()
-- -- 			hl.monitor({ output = laptop_screen_name, disabled = true })
-- -- 			refresh_delayed()
-- -- 		end, { timeout = 500, type = "oneshot" })
-- -- 	end
-- -- end)
--
-- -- hl.on("monitor.removed", function(m)
-- -- 	local monitors = hl.get_monitors()
-- -- 	if #monitors ~= 1 or m.name == laptop_screen_name then
-- -- 		return
-- -- 	end
-- -- 	-- aha https://github.com/hyprwm/Hyprland/pull/14547
-- -- 	-- TODO remove unnecessary reload when the bug is fixed.
-- -- 	hl.exec_cmd("hyprctl reload")
-- -- 	hl.monitor({ output = laptop_screen_name, mode = "preferred", position = "auto", scale = 1, disabled = false })
-- -- 	refresh_delayed()
-- -- end)
--
-- -- hl.on("monitor.layout_changed", function()
-- -- 	refresh_delayed()
-- -- end)

hl.bind("XF86Display", function()
	if hl.get_monitor(laptop_screen_name) then
		hl.monitor({ output = laptop_screen_name, disabled = true })
	else
		hl.monitor({ output = laptop_screen_name, mode = "preferred", position = "auto", scale = 1, disabled = false })
	end
	-- refresh_delayed()
end)
