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
    -- Theming
    use 'lifepillar/gruvbox8'
    use 'goolord/alpha-nvim'
    -- Visual
    use 'akinsho/bufferline.nvim'
    use 'folke/which-key.nvim'
    use 'norcalli/nvim-colorizer.lua'

    -- Movement
    use {'nvim-telescope/telescope.nvim',
        opt = true,
        cmd = 'Telescope',
        config = 'require(nitay.telescope)',
        requires = {
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzy-native.nvim' },
            { 'kyazdani42/nvim-web-devicons' }}}
    use { 'yashlala/vim-sayonara', opt = true, cmd = 'Sayonara', config = "require('nitay.sayonara'}" }
    --use 'ThePrimeagen/harpoon'
    use { 'rlane/pounce.nvim', opt = true, cmd = 'Pounce', config = "require('nitay.pounce'}" }
    use { 'is0n/fm-nvim', opt = true, cmd = 'Lf', config = "require('nitay.fm-nvim'}" }

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    --Treesitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    -- Completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-nvim-lsp'
    -- Snippets
    use 'saadparwaiz1/cmp_luasnip' -- snippet completions
    use 'rafamadriz/friendly-snippets' -- a bunch of snippets to use
    use 'L3MON4D3/LuaSnip' --snippet engine

    -- Git
    use { 'TimUntersberger/neogit', opt = true, cmd = 'Pounce', config = "require('nitay.git'}" }
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
    }

    --Other
    use 'lewis6991/impatient.nvim'

    use { 'vimwiki/vimwiki',
        opt = true,
        cmd = {'VimwikiMakeDiaryNote', 'VimwikiIndex' },
        config = "require('nitay.vimwiki'" }

    use 'numToStr/Comment.nvim'

    use 'akinsho/toggleterm.nvim'

    use 'wbthomason/packer.nvim' -- Packer can manage itself
    end
  })
