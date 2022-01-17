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

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

return packer.startup(function(use)
    -- Theming
    use 'lifepillar/gruvbox8'
    use {'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true} }

    -- Navigation
    use {'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' }, { 'nvim-telescope/telescope-fzy-native.nvim' }, { 'kyazdani42/nvim-web-devicons' } } }
    use 'kyazdani42/nvim-tree.lua'
    --use 'ThePrimeagen/harpoon'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'

    -- Completions
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip' -- snippet completions
    use 'rafamadriz/friendly-snippets' -- a bunch of snippets to use
    use 'L3MON4D3/LuaSnip' --snippet engine

    --Treesitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } -- Post-install/update hook with neovim command
    use {'p00f/nvim-ts-rainbow', requires = {'nvim-treesitter/nvim-treesitter'} }

    --Other
    use 'folke/which-key.nvim'
    use 'tpope/vim-fugitive'
    use 'vimwiki/vimwiki'
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    use 'lewis6991/impatient.nvim'
    use 'antoinemadec/FixCursorHold.nvim'
    use 'akinsho/bufferline.nvim'
    use 'akinsho/toggleterm.nvim'
    use 'goolord/alpha-nvim'
    use {
        'chipsenkbeil/distant.nvim',
        config = function()
            require('distant').setup {
                -- Applies Chip's personal settings to every machine you connect to
                --
                -- 1. Ensures that distant servers terminate with no connections
                -- 2. Provides navigation bindings for remote directories
                -- 3. Provides keybinding to jump into a remote file's parent directory
                ['*'] = require('distant.settings').chip_default()
            }
        end
    }

    use 'wbthomason/packer.nvim' -- Packer can manage itself
    config = {
        -- Move to lua dir so impatient.nvim can cache it
        compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
    }
end)