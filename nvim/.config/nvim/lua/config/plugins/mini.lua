return {
	{
		"echasnovski/mini.ai",
		version = "*",
		config = function()
			require("mini.ai").setup()
		end,
		event = "CursorMoved",
	},

	{
		"echasnovski/mini.align",
		version = false,
		config = function()
			require("mini.align").setup()
		end,
		keys = "ga",
	},
	-- {
	-- 	"echasnovski/mini.indentscope",
	-- 	version = false,
	-- 	config = function()
	-- 		require("mini.indentscope").setup()
	-- 	end,
	-- 	event = "VeryLazy",
	-- },
	{
		"echasnovski/mini.move",
		version = false,
		config = function()
			require("mini.move").setup()
		end,
		keys = { "<M-h>", "<M-j>", "<M-k>", "<M-l>" },
	},
}
