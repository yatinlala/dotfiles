require("config.options")
require("config.lazy")
require("config.autocmds").setup()
require("config.keymaps")
require("config.commands")

-- require("util").setColors()

-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "VeryLazy",
-- 	callback = function()
-- 	end,
-- })
