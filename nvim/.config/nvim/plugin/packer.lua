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
  -- use {'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true} }
  use 'vimwiki/vimwiki'
  use 'tpope/vim-fugitive'
  use {'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' }, { 'nvim-telescope/telescope-fzy-native.nvim' }, { 'kyazdani42/nvim-web-devicons' } } }
  use 'ThePrimeagen/harpoon'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } -- Post-install/update hook with neovim command
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-compe'
end)
