local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
    -- THEMING
    use { 'lifepillar/gruvbox8',
        config = function()
            require('plugin.config.colorscheme')
        end,
    }
    -- use {
    --     'nvim-lualine/lualine.nvim',
    --     requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    --     config = function()
    --         require('plugin.config.statusline')
    --     end,
    --     after = 'gruvbox8',
    -- }

    -- VISUAL
    use { 'akinsho/bufferline.nvim',
        config = function()
            require('plugin.config.bufferline')
        end,
        after = 'gruvbox8',
    }

    use { 'folke/which-key.nvim',
    config = function()
        require('plugin.config.whichkey')
    end,
    --[[ keys = '<leader>'  ]]}

    -- Movement
    use { 'rlane/pounce.nvim', cmd = 'Pounce', keys = 's',
        config = function()
            vim.api.nvim_set_keymap("n", "s", ":Pounce<CR>", {})
        end,
    }
    use { 'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzy-native.nvim' },
            { 'kyazdani42/nvim-web-devicons' }},
        config = function ()
            require('plugin.config.telescope')
        end,
        cmd = 'Telescope'
        }
    use { 'yashlala/vim-sayonara',
    config = function()
        require('plugin.config.sayonara')
         vim.api.nvim_set_keymap('n', 'gs', ':Sayonara<CR>', { silent = true } )
         vim.api.nvim_set_keymap('n', 'gS', ':Sayonara!<CR>', { silent = true } )
        end,
    keys = { 'gs', 'gS' },
    cmd = { 'Sayonara', 'Sayonara!'  } }

    --use 'ThePrimeagen/harpoon'

    -- use { 'rlane/pounce.nvim',
    --     config = function()
    --         require('plugin.config.pounce')
    --         -- Pounce around
    --         vim.api.nvim_set_keymap("n", "s", ":Pounce<cr>", {silent = true } )
    --     end,
    --     keys = 's'
    -- }

    use {'is0n/fm-nvim',
        config = function()
           require('plugin.config.fm-nvim')
           end,
        keys = '<leader>e',
        cmd = 'Lf'
    }

    use { 'williamboman/nvim-lsp-installer', event = 'CursorMoved' }
    use { 'neovim/nvim-lspconfig',
        config = function()
            require('plugin.config.lsp')
        end,
        after = 'nvim-lsp-installer',
    }

    use { 'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('plugin.config.treesitter')
        end,
        after = 'nvim-lsp-installer',
    }

    use { 'norcalli/nvim-colorizer.lua',
        config = function()
            require 'colorizer'.setup()
        end,
        after = 'nvim-treesitter',
    }

    -- Completion
    use { 'hrsh7th/nvim-cmp',
        config = function ()
            require('plugin.config.cmp')
        end,
        event = 'InsertEnter' }
    use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-path', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' }
    use {'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' }  -- snippet completions
    use { 'rafamadriz/friendly-snippets', after = 'nvim-cmp' } -- a bunch of snippets to use
    use { 'L3MON4D3/LuaSnip', after = 'nvim-cmp' } --snippet engine

    -- Git
    use { 'TimUntersberger/neogit',
        config = function()
            require('plugin.config.neogit')
            end,
        cmd = 'Neogit'
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('plugin.config.gitsigns')
        end,
        after = 'nvim-lsp-installer'
    }

    --Other
    use 'lewis6991/impatient.nvim'
    use { 'vimwiki/vimwiki',
        config = function()
            require('plugin.config.vimwiki')
        end,
        after = 'nvim-lsp-installer' }

    use { 'numToStr/Comment.nvim',
        config = function()
            require('plugin.config.comment')
        end,
        event = 'CursorMoved' }

    use { 'akinsho/toggleterm.nvim',
        config = function ()
            require('plugin.config.toggleterm')
        end,
        after = 'gruvbox8'
    }

    use {
        'chipsenkbeil/distant.nvim',
        config = function()
            require('distant').setup {
                -- 1. Ensures that distant servers terminate with no connections
                -- 2. Provides navigation bindings for remote directories
                -- 3. Provides keybinding to jump into a remote file's parent directory
                ['*'] = require('distant.settings').chip_default()
            }
        end,
        cmd = 'DistantLaunch'
    }

    use { 'wbthomason/packer.nvim', }
  if packer_bootstrap then
    require('packer').sync()
    end
end)
