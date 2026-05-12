-- ------------------
-- ---- MONITORS ----
-- ------------------
-- {{{
-- -- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

local laptop_screen_name = "eDP-1"
hl.monitor({ output = laptop_screen_name, disabled = true })

hl.on("monitor.added", function(m)
	if m.name ~= laptop_screen_name then
		hl.timer(function()
			hl.monitor({ output = laptop_screen_name, disabled = true })
		end, { timeout = 500, type = "oneshot" })
	end
end)

hl.on("monitor.removed", function(m)
	if m.name ~= laptop_screen_name then
		local monitors = hl.get_monitors()
		local has_external = false
		for _, mon in ipairs(monitors) do
			if mon.name ~= laptop_screen_name then
				has_external = true
				break
			end
		end
		if not has_external then
			hl.monitor({ output = laptop_screen_name, mode = "preferred", position = "auto", scale = "1" })
		end
	end
end)

hl.bind("XF86Display", function()
	if hl.get_monitor(laptop_screen_name) then
		hl.monitor({ output = laptop_screen_name, disabled = true })
	else
		-- TODO this is broken. need to report
		-- hl.monitor({ output = laptop_screen_name, mode = "preferred", position = "auto", scale = 1 })
		hl.exec_cmd("hyprctl reload") -- TEMPORARY WORKAROUND
	end
end)
