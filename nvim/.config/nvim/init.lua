require("util")
require("config.options")
require("config.globals")
require("config.lazy")
require("config.autocmds").setup()
require("config.keymaps")

-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "VeryLazy",
-- 	callback = function()
-- 	end,
-- })

require("util").setColors()
