require("util")
require("config.options")
require("config.globals")
require("config.lazy")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("config.autocmds").setup()
		require("config.keymaps")
	end,
})
require("util").setColors()
