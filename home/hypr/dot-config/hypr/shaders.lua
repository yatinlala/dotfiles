-- shaders.lua
local HOME = os.getenv("HOME")
local SHADER_DIR = HOME .. "/.config/hypr/shaders"

local M = {}
local _states = {}

function M.toggle(shader)
	_states[shader] = not _states[shader]
	local path = _states[shader] and (SHADER_DIR .. "/" .. shader) or ""
	hl.config({ decoration = { screen_shader = path } })
end

return M
