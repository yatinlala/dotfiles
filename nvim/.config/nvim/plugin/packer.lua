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
  use 'lifepillar/gruvbox8'
  use 'sickill/vim-monokai'
  use {'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true} }
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } -- Post-install/update hook with neovim command
  use 'tpope/vim-fugitive'
  use 'vimwiki/vimwiki'
  use {'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' }, { 'nvim-telescope/telescope-fzy-native.nvim' }, { 'kyazdani42/nvim-web-devicons' } } }
  -- use 'ThePrimeagen/harpoon'
  use 'justinmk/vim-sneak'
  use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines

  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'hrsh7th/nvim-compe'
end)
