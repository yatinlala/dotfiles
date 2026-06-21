require("autostart")
require("environment")
require("input")
require("keybinds")
require("monitors")
require("rules")
require("permissions")
require("shaders")
require("hlconfig")

local function log(line)
	local f = io.open(os.getenv("XDG_CACHE_HOME") .. "/hyprlog.txt", "a")
	if not f then
		return
	end
	f:write(line .. "\n")
	f:close()
end

-- TODOS
-- figure out why stubfile isnt working for hl.on callbacks.
-- restructure things to actually make sense / trim fat

-- vim:foldmethod=marker:foldlevel=0
