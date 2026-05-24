-- -------------------
-- -- SCRATCHPADS ----
-- -------------------
-- Size/position config for each scratchpad class, matching keybinds.lua.
-- Provides refresh_geometries() to recalculate all visible scratchpad
-- windows when monitors change.

local scratchpad_config = {
	ferdium = {
		width = 0.96,
		height = 0.9,
	},
	obsidian = {
		width = 0.96,
		height = 0.88,
	},
	signal = {
		width = 0.9,
		height = 0.9,
	},
	Spotify = {
		width = 0.8,
		height = 0.8,
	},
}

local function refresh_geometries()
	local monitor = hl.get_active_monitor()
	if not monitor then
		return
	end

	-- Save focus so resize/move dispatches don't steal it
	local focused = hl.get_active_window()
	local focused_addr = focused and focused.address and "address:" .. focused.address

	local mw = math.floor(monitor.width / monitor.scale)
	local mh = math.floor(monitor.height / monitor.scale)

	for _, window in ipairs(hl.get_windows()) do
		local ws = window.workspace
		if ws and ws.name then
			local name = ws.name:match("^special:(.+)$")
			if name then
				local cfg = scratchpad_config[name]
				if cfg then
					local ww = math.floor(mw * cfg.width)
					local wh = math.floor(mh * cfg.height)
					local x = monitor.x + math.floor((mw - ww) / 2)
					local y = monitor.y + math.floor((mh - wh) / 2)

					local sel = "address:" .. window.address
					hl.dispatch(hl.dsp.window.resize({ window = sel, x = ww, y = wh, relative = false }))
					hl.dispatch(hl.dsp.window.move({ window = sel, x = x, y = y, relative = false }))
				end
			end
		end
	end

	-- Restore focus
	if focused_addr then
		hl.dispatch(hl.dsp.focus({ window = focused_addr }))
	end
end

return {
	refresh_geometries = refresh_geometries,
}
