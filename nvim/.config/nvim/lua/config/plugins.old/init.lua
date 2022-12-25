--- VISUAL ---
use({
	"SmiteshP/nvim-navic",
	requires = "neovim/nvim-lspconfig",
})

--- COMPLETION ---
use({
	"hrsh7th/nvim-cmp",
	config = function()
		require("plugin.config.nvim-cmp")
	end,
	event = "InsertEnter",
})
use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
use({ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" })
use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
use({ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" }) -- snippet completions
use({ "rafamadriz/friendly-snippets", after = "nvim-cmp" }) -- a bunch of snippets to use
use({ "L3MON4D3/LuaSnip", after = "nvim-cmp" }) --snippet engine

use({
	"lewis6991/gitsigns.nvim",
	requires = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("plugin.config.gitsigns-nvim")
	end,
})

--- Other ---
use({ "Djancyp/cheat-sheet" })
use({
	"antoinemadec/FixCursorHold.nvim",
	config = function()
		vim.g.cursorhold_updatetime = 100
	end,
})
-- use { 'milkypostman/vim-togglelist',
--     config = function()
--         vim.g.toggle_list_no_mappings = 1
--     end,
-- }

use({
	"folke/trouble.nvim",
	requires = "kyazdani42/nvim-web-devicons",
	config = function()
		require("trouble").setup({})
		vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", { silent = true, noremap = true })
	end,
})
use({
	"nvim-orgmode/orgmode",
	config = function()
		-- Load custom tree-sitter grammar for org filetype
		require("orgmode").setup_ts_grammar()

		-- Tree-sitter configuration
		require("nvim-treesitter.configs").setup({
			-- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "org" }, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
			},
			ensure_installed = { "org" }, -- Or run :TSUpdate org
		})

		require("orgmode").setup({
			org_agenda_files = { "~/documents/org/*", "~/documents/org/my-orgs/**/*" },
			org_default_notes_file = "~/documents/org/refile.org",
		})
	end,
	requires = "nvim-treesitter/nvim-treesitter",
})
use({
	"akinsho/toggleterm.nvim",
	config = function()
		require("plugin.config.toggleterm")
	end,
	-- cmd = 'ToggleTerm',
})
-- use { 'chipsenkbeil/distant.nvim',
--     config = function()
--         require('distant').setup {
--             ['*'] = require('distant.settings').chip_default()
--         }
--     end,
--     cmd = 'DistantLaunch'
-- }
use({
	"tamton-aquib/duck.nvim",
	config = function()
		vim.keymap.set("n", "<leader>Dh", function()
			require("duck").hatch()
		end, {})
		vim.keymap.set("n", "<leader>Dk", function()
			require("duck").cook()
		end, {})
	end,
})
