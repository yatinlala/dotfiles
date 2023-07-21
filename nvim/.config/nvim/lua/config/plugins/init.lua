return {
  {
    'yatinlala/neovim.nvim',
    dir = '~/code/neovim/neovim.nvim',
    config = true,
    enabled = false,
    lazy = false,
  },
  {
    'stevearc/dressing.nvim',
    config = true,
    lazy = 'VeryLazy',
    opts = {},
  },
  { 'tamton-aquib/duck.nvim' },
  { 'lewis6991/gitsigns.nvim', config = true, event = 'BufWinEnter' },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufWinEnter',
    config = function()
      require('indent_blankline').setup {
        char = '┆',
      }
    end,
  },
  { 'yashlala/marker.nvim' },
  {
    'ethanholz/nvim-lastplace',
    event = 'BufWinEnter',
    config = true,
  },
  {
    'kylechui/nvim-surround',
    keys = { 'ys', 'ds', 'cs' },
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    config = true,
  },
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup {}
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufWinEnter',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('treesitter-context').setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
    end,
  },
  { 'ThePrimeagen/vim-be-good', cmd = 'VimBeGood' },
  { 'tpope/vim-sleuth', event = 'BufReadPost' },

  ------------------------------------------------------
  -- {
  --   'folke/noice.nvim',
  --   config = function()
  --     require('noice').setup {
  --       cmdline = {
  --         view = 'cmdline',
  --       },
  --     }
  --   end,
  --   lazy = false,
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'rcarriga/nvim-notify',
  --   },
  -- },
  -- {
  --   'rcarriga/nvim-notify',
  --   config = function()
  --     require('notify').setup {
  --       background_colour = 'Normal',
  --       fps = 30,
  --       level = 2,
  --       minimum_width = 50,
  --       render = 'compact',
  --       stages = 'fade',
  --       timeout = 2500,
  --       top_down = true,
  --     }
  --   end,
  -- },
  -- { 'liuchengxu/vim-clap', lazy = false, build = ':call clap#installer#build_maple()' },
  -- { "Bekaboo/dropbar.nvim", lazy = false },
  -- {
  -- 	"nvim-orgmode/orgmode",
  -- 	-- event = "VeryLazy",
  -- 	lazy = false,
  -- 	dependencies = "nvim-treesitter/nvim-treesitter",
  -- 	config = function()
  -- 		require("orgmode").setup_ts_grammar()
  -- 		require("orgmode").setup({
  -- 			org_agenda_files = "~/documents/org/*",
  -- 			org_default_notes_file = "~/documents/org/main.org",
  -- 		})
  -- 	end,
  -- },
  -- {
  -- 	"utilyre/barbecue.nvim",
  -- 	name = "barbecue",
  -- 	version = "*",
  -- 	-- event = "VeryLazy",
  -- 	dependencies = {
  -- 		"SmiteshP/nvim-navic",
  -- 		"nvim-tree/nvim-web-devicons", -- optional dependency
  -- 	},
  -- },
  -- {
  -- 	"nvim-neorg/neorg",
  -- 	event = "VeryLazy",
  -- 	build = ":Neorg sync-parsers",
  -- 	config = function()
  -- 		require("neorg").setup({
  -- 			load = {
  -- 				["core.defaults"] = {},
  -- 				["core.concealer"] = {},
  -- 				["core.dirman"] = { -- Manage your directories with Neorg
  -- 					config = {
  -- 						workspaces = {
  -- 							notes = "~/documents/org",
  -- 						},
  -- 						default_workspace = "notes",
  -- 						--[[ autodetect = true, ]]
  -- 						--[[ autochdir = true, ]]
  -- 					},
  -- 				},
  -- 			},
  -- 		})
  -- 	end,
  -- 	dependencies = {
  -- 		{ "nvim-lua/plenary.nvim" },
  -- 		{
  -- 			"nvim-treesitter/nvim-treesitter",
  -- 			opts = {
  -- 				auto_install = true,
  -- 				highlight = {
  -- 					enable = true,
  -- 					additional_vim_regex_highlighting = false,
  -- 				},
  -- 			},
  -- 			config = function(_, opts)
  -- 				require("nvim-treesitter.configs").setup(opts)
  -- 			end,
  -- 		},
  -- 	},
  -- },
  -- {
  -- 	"jcdickinson/codeium.nvim",
  -- 	dependencies = {
  -- 		"nvim-lua/plenary.nvim",
  -- 		"hrsh7th/nvim-cmp",
  -- 	},
  -- 	config = function()
  -- 		require("codeium").setup({})
  --
  -- 		vim.g.codeium_disable_bindings = 1
  -- 		vim.keymap.set("i", "<C-g>", function()
  -- 			return vim.fn["codeium#Accept"]()
  -- 		end, { expr = true })
  -- 		vim.keymap.set("i", "<c-;>", function()
  -- 			return vim.fn["codeium#CycleCompletions"](1)
  -- 		end, { expr = true })
  -- 		vim.keymap.set("i", "<c-,>", function()
  -- 			return vim.fn["codeium#CycleCompletions"](-1)
  -- 		end, { expr = true })
  -- 		vim.keymap.set("i", "<c-x>", function()
  -- 			return vim.fn["codeium#Clear"]()
  -- 		end, { expr = true })
  -- 		vim.cmd([[let g:codeium_enabled = v:false]])
  -- 	end,
  -- 	event = "VeryLazy",
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
