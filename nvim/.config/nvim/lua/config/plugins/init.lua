return {
	{ "lifepillar/vim-gruvbox8" },
	{ "tamton-aquib/duck.nvim" },
	{
		"yashlala/vim-sayonara",
		keys = { "gs", "gS" },
		config = function()
			vim.g.sayonara_confirm_quit = true
			vim.g.sayonara_dont_quit = true
			vim.keymap.set("n", "gs", ":Sayonara<CR>", { silent = true })
			vim.keymap.set("n", "gS", ":Sayonara!<CR>", { silent = true })
		end,
	},
	{
		"kylechui/nvim-surround",
		keys = { "ys", "ds", "cs" },
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup()
		end,
	},

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
		init = function()
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
	{ "lewis6991/gitsigns.nvim", config = true, event = "BufWinEnter" },
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"kyazdani42/nvim-web-devicons", -- optional dependency
		},
		opts = {
			-- configurations go here
		},
		event = "BufWinEnter",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufWinEnter",
		config = function()
			require("indent_blankline").setup({
				char = "┆",
			})
		end,
	},

	{
		"nvim-orgmode/orgmode",
		-- event = "VeryLazy",
		lazy = false,
		dependencies = 'nvim-treesitter/nvim-treesitter',
		config = function()
			require("orgmode").setup_ts_grammar()
			require("orgmode").setup({
				org_agenda_files = "~/documents/org/*",
				org_default_notes_file = "~/documents/org/refile.org",
			})
		end,
	},
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

	{
	    "folke/noice.nvim",
	    config = function()
	        require("noice").setup({
	            cmdline = {
	                view = "cmdline",
	            },
	        })
	    end,
	    lazy = false,
	    dependencies = {
	        "MunifTanjim/nui.nvim",
	        "rcarriga/nvim-notify",
	    },
	},
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
