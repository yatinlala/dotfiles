local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    Packer_Bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

return require('packer').startup(function(use)
    --- VISUAL ---
    use { 'lifepillar/vim-gruvbox8',
        config = function()
            require('plugin.config.colorscheme')
        end,
    }
    use { 'akinsho/bufferline.nvim',
        config = function()
            require('plugin.config.bufferline')
        end,
    }
    use { 'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require('plugin.config.lualine')
        end,
    }
    -- use({
    --     "folke/noice.nvim",
    --     event = "VimEnter",
    --     config = function()
    --         require("noice").setup()
    --     end,
    --     requires = {
    --         -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    --         "MunifTanjim/nui.nvim",
    --         -- OPTIONAL:
    --         --   `nvim-notify` is only needed, if you want to use the notification view.
    --         --   If not available, we use `mini` as the fallback
    --         "rcarriga/nvim-notify",
    --     }
    -- })
    use {
        "SmiteshP/nvim-navic",
        requires = "neovim/nvim-lspconfig"
    }
    use { 'folke/which-key.nvim',
        config = function()
            require('plugin.config.whichkey')
        end,
    }
    use 'baskerville/vim-sxhkdrc'

    --- TEXT MOTIONS ---
    use { 'tpope/vim-surround', event = 'CursorMoved' }
    use { 'numToStr/Comment.nvim',
        config = function()
            require('plugin.config.comment')
        end,
        event = 'CursorMoved' }

    --- FILE MOTIONS ---
    use { 'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'kyazdani42/nvim-web-devicons' },
            { 'nvim-telescope/telescope-fzy-native.nvim' } },
        config = function()
            require('plugin.config.telescope-nvim')
        end,
    }
    use { 'yashlala/vim-sayonara',
        config = function()
            require('plugin.config.sayonara')
            vim.api.nvim_set_keymap('n', 'gs', ':Sayonara<CR>', { silent = true })
            vim.api.nvim_set_keymap('n', 'gS', ':Sayonara!<CR>', { silent = true })
        end,
        keys = { 'gs', 'gS' },
        cmd = { 'Sayonara', 'Sayonara!' } }
    use { 'is0n/fm-nvim',
        config = function()
            require('plugin.config.fm-nvim')
        end,
        -- keys = '<leader>e',
        -- cmd = 'Lf'
    }
    --use 'ThePrimeagen/harpoon'

--- LSP & TREESITTER ---
    -- use { 'williamboman/nvim-lsp-installer',
    --     config = function()
    --         require('plugin.config.lsp.lsp-installer')
    --     end,
    -- }
    use {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
        end,
    }
    use {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup()
        end,
        after = 'mason.nvim',
    }
    use { 'neovim/nvim-lspconfig',
        config = function()
            require('plugin.config.lsp.lspconfig')
        end,
        after = 'mason-lspconfig.nvim'
    }
    use { 'nvim-treesitter/nvim-treesitter',
        -- run = ':TSUpdate',
        config = function()
            require('plugin.config.treesitter')
        end,
    }
    -- use { 'jose-elias-alvarez/null-ls.nvim',
    --     config = function()
    --         require('plugin.config.lsp.null-ls')
    --     end,
    --     after = 'nvim-lsp-installer',
    -- }
    use { 'norcalli/nvim-colorizer.lua',
        config = function()
            require('plugin.config.nvim-colorizer')
        end,
        cmd = 'ColorizerToggle'
    }
    use { 'RRethy/vim-illuminate',
        config = function()
            require('plugin.config.illuminate')
        end,
    }

    --- COMPLETION ---
    use { 'hrsh7th/nvim-cmp',
        config = function()
            require('plugin.config.nvim-cmp')
        end,
        event = 'InsertEnter' }
    use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-path', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' }
    use { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' } -- snippet completions
    use { 'rafamadriz/friendly-snippets', after = 'nvim-cmp' } -- a bunch of snippets to use
    use { 'L3MON4D3/LuaSnip', after = 'nvim-cmp' } --snippet engine

    -- Git ---
    -- use { 'TimUntersberger/neogit',
    --     config = function()
    --         require('plugin.config.neogit')
    --     end,
    --     -- cmd = 'Neogit'
    -- }
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('plugin.config.gitsigns-nvim')
        end,
    }

    --- Other ---
    use 'lewis6991/impatient.nvim'
    use {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
            }
        end
    }
    use { "Djancyp/cheat-sheet" }
    use {
        'antoinemadec/FixCursorHold.nvim',
        config = function()
            vim.g.cursorhold_updatetime = 100
        end,
    }
    use { 'vimwiki/vimwiki',
        config = function()
            require('plugin.config.vimwiki')
        end,
    }
    -- use { 'milkypostman/vim-togglelist',
    --     config = function()
    --         vim.g.toggle_list_no_mappings = 1
    --     end,
    -- }

    use { 'ThePrimeagen/vim-be-good' }
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {}
            vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", { silent = true, noremap = true })
        end
    }
    use { 'nvim-orgmode/orgmode',
        config = function()
            -- Load custom tree-sitter grammar for org filetype
            require('orgmode').setup_ts_grammar()

            -- Tree-sitter configuration
            require 'nvim-treesitter.configs'.setup {
                -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { 'org' }, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
                },
                ensure_installed = { 'org' }, -- Or run :TSUpdate org
            }

            require('orgmode').setup({
                org_agenda_files = { '~/documents/org/*', '~/documents/org/my-orgs/**/*' },
                org_default_notes_file = '~/documents/org/refile.org',
            })
        end,
        requires = 'nvim-treesitter/nvim-treesitter'
    }
    use { 'akinsho/toggleterm.nvim',
        config = function()
            require('plugin.config.toggleterm')
        end,
        -- cmd = 'ToggleTerm',
    }
    use { 'romainl/vim-cool' }
    -- use { 'chipsenkbeil/distant.nvim',
    --     config = function()
    --         require('distant').setup {
    --             ['*'] = require('distant.settings').chip_default()
    --         }
    --     end,
    --     cmd = 'DistantLaunch'
    -- }
    use { 'wbthomason/packer.nvim', }
    if Packer_Bootstrap then
        require('packer').sync()
    end
end)
