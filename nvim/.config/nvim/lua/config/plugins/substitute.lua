return {
	"gbprod/substitute.nvim",
	keys = { "s", "ss", "S", "vs" },
	config = function()
		require("substitute").setup({
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		})
		vim.keymap.set("n", "s", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
		vim.keymap.set("n", "ss", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
		vim.keymap.set("n", "S", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
		vim.keymap.set("x", "s", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })
	end,
}
