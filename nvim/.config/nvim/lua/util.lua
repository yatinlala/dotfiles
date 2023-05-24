_G.P = function(v)
	print(vim.inspect(v))
	return v
end

_G.RELOAD = function(...)
	return require("plenary.reload").reload_module(...)
end

_G.R = function(name)
	RELOAD(name)
	return require(name)
end

local M = {}

function M.toggleBg()
	if vim.o.background == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
end

function M.setColors()
	vim.cmd("colorscheme gruvbox")
	vim.cmd([[
        hi def IlluminatedWordText guibg=#504945
        hi def IlluminatedWordRead guibg=#504945
        hi def IlluminatedWordWrite guibg=#504945
        hi MatchWord cterm=underline gui=underline
    ]])
end

return M
