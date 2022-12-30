return {
	{ "lifepillar/vim-gruvbox8", lazy = false },
	{ "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({})
		end,
	},

	{ "tamton-aquib/duck.nvim" },
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
			vim.g.matchup_matchparen_deferred = 1
			vim.b.matchup_matchparen_enabled = 0
		end,
	},
	{
		"ethanholz/nvim-lastplace",
		event = "BufWinEnter",
		config = true,
	},

	--  { "tpope/vim-dispatch" },
	--  { "tpope/vim-sleuth" },
	--  { "tpope/vim-repeat" },
	--  { "tpope/vim-surround" },
	--  { "tpope/vim-unimpaired" },
	--  { "tpope/vim-rhubarb" },
	--  { "tpope/vim-eunuch" },
	--  { "tpope/vim-obsession" },
	--  { "tpope/vim-sexp-mappings-for-regular-people", ft = { "clojure" } },
	--  { "guns/vim-sexp", ft = { "clojure" } },
	--  {
	--    "norcalli/nvim-terminal.lua",
	--    ft = "terminal",
	--    config = function()
	--      require("terminal").setup()
	--    end,
	--  },
	--
	--  {
	--    "folke/persistence.nvim",
	--    event = "BufReadPre",
	--    config = function()
	--      require("persistence").setup({
	--        options = { "buffers", "curdir", "tabpages", "winsize", "help" },
	--      })
	--    end,
	--  },
	--
	--  {
	--    "andymass/vim-matchup",
	--    event = "BufReadPost",
	--    config = function()
	--      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
	--    end,
	--  },
}
