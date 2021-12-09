-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
 
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end
 
-- Automatically PackerCompile
vim.api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]],
  false
)


return require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Packer can manage itself

  -- Theming
  use 'lifepillar/gruvbox8'
  use {'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true} }

  -- Navigation
  use {'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' }, { 'nvim-telescope/telescope-fzy-native.nvim' }, { 'kyazdani42/nvim-web-devicons' } } }
  use 'justinmk/vim-sneak'
  -- use 'ThePrimeagen/harpoon'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } -- Post-install/update hook with neovim command
  use 'williamboman/nvim-lsp-installer'
  use 'onsails/lspkind-nvim'

  -- Copmletions
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'

  use 'tpope/vim-fugitive'
  use 'vimwiki/vimwiki'
  use {
      'numToStr/Comment.nvim',
      config = function()
          require('Comment').setup()
      end
  }
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
end)
