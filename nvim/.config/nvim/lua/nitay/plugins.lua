local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

return packer.startup({function(use)
    -- THEMING
    use 'lifepillar/gruvbox8'
    use 'goolord/alpha-nvim'

    -- VISUAL
    use 'akinsho/bufferline.nvim'

    use { 'folke/which-key.nvim',
    config = function()
        require('nitay.whichkey')
    end,
    keys = '<leader>' }

    -- Movement
    use {'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzy-native.nvim' },
            { 'kyazdani42/nvim-web-devicons' }},
        config = function ()
            require('nitay.telescope')
        end,
        cmd = 'Telescope'
        }

    use { 'yashlala/vim-sayonara',
    config = function()
        require('nitay.sayonara')
         vim.api.nvim_set_keymap('n', 'gs', ':Sayonara<CR>', { silent = true } )
         vim.api.nvim_set_keymap('n', 'gS', ':Sayonara!<CR>', { silent = true } )
        end,
    keys = { 'gs', 'gS' } }

    --use 'ThePrimeagen/harpoon'

    use { 'rlane/pounce.nvim',
        config = function()
            require('nitay.pounce')
            -- Pounce around
            vim.api.nvim_set_keymap("n", "s", ":Pounce<cr>", {silent = true } )
        end,
        keys = 's'
    }

    use {'is0n/fm-nvim',
        config = function()
           require('nitay.fm-nvim')
            vim.api.nvim_set_keymap("n", "<C-a>", ":Lf<cr>", { silent = true } )
           end,
        keys = '<C-a>',
        cmd = 'Lf'
    }

    use { 'williamboman/nvim-lsp-installer',
        after = 'packer',
    }
    use { 'neovim/nvim-lspconfig',
        config = function()
            require('nitay.lsp')
        end,
        after = 'nvim-lsp-installer'
    }

    use {'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        event = 'BufWinEnter',
        config = function()
            require('nitay.treesitter')
        end
    }

    use { 'norcalli/nvim-colorizer.lua',
        config = function()
            require 'colorizer'.setup()
        end,
        event = 'BufWinEnter'
    }

    -- Completion
    use { 'hrsh7th/nvim-cmp',
        config = function ()
            require('nitay.cmp')
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
            require('nitay.neogit')
            end,
        cmd = 'Neogit'
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        -- tag = 'release' -- To use the latest release
    }

    --Other
    use 'lewis6991/impatient.nvim'
    use 'vimwiki/vimwiki'
    use { 'numToStr/Comment.nvim',
        config = function()
            require('nitay.comment')
        end,
        event = 'CursorMoved'}

    use { 'akinsho/toggleterm.nvim',
        config = function ()
            require('nitay.toggleterm')
        end,
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

    use { 'wbthomason/packer.nvim',
        event = 'VimEnter' }
    end,
  })
