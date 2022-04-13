local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
    -- THEMING
    use { 'ellisonleao/gruvbox.nvim',
        config = function()
            require('plugin.config.colorscheme')
        end,
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require('plugin.config.statusline')
        end,
    }

    -- VISUAL
    use { 'akinsho/bufferline.nvim',
        config = function()
            require('plugin.config.bufferline')
        end,
        -- after = 'gruvbox8',
    }

    use { 'folke/which-key.nvim',
    config = function()
        require('plugin.config.whichkey')
    end,
    --[[ keys = '<leader>'  ]]}

    -- Movement
    use { 'tpope/vim-surround', event = 'CursorMoved' }
    use { 'rlane/pounce.nvim',
        config = function()
            require('plugin.config.pounce')
            -- Pounce around
            vim.api.nvim_set_keymap("n", "s", ":Pounce<cr>", {silent = true } )
        end,
        keys = 's',
        cmd = 'Pounce',
    }

    use { 'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'kyazdani42/nvim-web-devicons' },
            { 'nvim-telescope/telescope-fzy-native.nvim' } },
        config = function ()
            require('plugin.config.telescope-nvim')
        end,
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


    use {'is0n/fm-nvim',
        config = function()
           require('plugin.config.fm-nvim')
            vim.api.nvim_set_keymap('n', '<leader>e', ':Lf<CR>', {})
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
            require('plugin.config.nvim-colorizer')
        end,
        cmd = 'ColorizerToggle'
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
            require('plugin.config.gitsigns-nvim')
        end,
        event = 'BufRead'
    }

    --Other
    use 'lewis6991/impatient.nvim'
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

    use { 'numToStr/Comment.nvim',
        config = function()
            require('plugin.config.comment')
        end,
        event = 'CursorMoved' }

    use { 'akinsho/toggleterm.nvim',
        config = function ()
            require('plugin.config.toggleterm')
        end,
        cmd = 'ToggleTerm',
    }

    use {
        'chipsenkbeil/distant.nvim',
        config = function()
            require('distant').setup {
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
