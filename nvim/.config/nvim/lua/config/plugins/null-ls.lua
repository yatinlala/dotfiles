local M = {
	"jose-elias-alvarez/null-ls.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	event = "VeryLazy",
}

function M.config()
	local null_ls = require("null-ls")
	null_ls.setup({
		sources = {
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.shfmt,
			null_ls.builtins.diagnostics.eslint,
			null_ls.builtins.completion.spell,
		},
	})
end

return M
