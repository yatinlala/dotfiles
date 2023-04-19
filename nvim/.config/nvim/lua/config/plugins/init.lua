return {
	{ "lifepillar/vim-gruvbox8" },
	{ "tamton-aquib/duck.nvim" },
	{ "tpope/vim-sleuth", event = "BufReadPost" },
	{ "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({})
		end,
	},
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
		setup = function()
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

	-- {
	-- 	"nvim-orgmode/orgmode",
	-- 	lazy = false,
	-- 	config = function()
	-- 		require("orgmode").setup_ts_grammar()
	-- 		require("orgmode").setup({
	-- 			org_agenda_files = "~/documents/org/*",
	-- 			org_default_notes_file = "~/documents/org/refile.org",
	-- 		})
	-- 	end,
	-- },
	{
		"jcdickinson/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		-- config = function()
		-- 	require("codeium").setup({})
		-- end,
		lazy = true,
	},

	-- {
	--     "folke/noice.nvim",
	--     config = function()
	--         require("noice").setup({
	--             cmdline = {
	--                 view = "cmdline",
	--             },
	--         })
	--     end,
	--     lazy = false,
	--     dependencies = {
	--         "MunifTanjim/nui.nvim",
	--         "rcarriga/nvim-notify",
	--     },
	-- },
	-- {
	--     "rcarriga/nvim-notify",
	--     config = function()
	--         require("notify").setup({
	--             background_colour = "Normal",
	--             fps = 30,
	--             level = 2,
	--             minimum_width = 50,
	--             render = "compact",
	--             stages = "fade",
	--             timeout = 2500,
	--             top_down = true,
	--         })
	--     end,
	-- },
	-- {
	--     "Exafunction/codeium.vim",
	--     cmd = "Codeium",
	--     setup = function()
	--         vim.g.codeium_disable_bindings = 1
	--         vim.g.codeium_enabled = false
	--     end,
	--     config = function()
	--         vim.keymap.set("i", "<C-g>", function()
	--             return vim.fn["codeium#Accept"]()
	--         end, { expr = true })
	--         vim.keymap.set("i", "<c-;>", function()
	--             return vim.fn["codeium#CycleCompletions"](1)
	--         end, { expr = true })
	--         vim.keymap.set("i", "<c-,>", function()
	--             return vim.fn["codeium#CycleCompletions"](-1)
	--         end, { expr = true })
	--         vim.keymap.set("i", "<c-x>", function()
	--             return vim.fn["codeium#Clear"]()
	--         end, { expr = true })
	--     end,
	-- },

	--  { "tpope/vim-dispatch" },
	--  { "tpope/vim-repeat" },
	--  { "tpope/vim-surround" },
	--  { "tpope/vim-unimpaired" },
	--  { "tpope/vim-eunuch" },
	--  { "tpope/vim-obsession" },
	--  { "tpope/vim-sexp-mappings-for-regular-people", ft = { "clojure" } },
	--  { "guns/vim-sexp", ft = { "clojure" } },
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
}
