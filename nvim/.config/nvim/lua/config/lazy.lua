-- boostrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'git@github.com:folke/lazy.nvim.git',
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

-- load plugins
require('lazy').setup('config.plugins', {
  defaults = { lazy = true },
  install = { colorscheme = { 'gruvbox.nvim' } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'zip',
        'zipPlugin',
        'fzf',
        'tar',
        'tarPlugin',
        'getscript',
        'getscriptPlugin',
        'vimball',
        'vimballPlugin',
        '2html_plugin',
        'matchit',
        'matchparen',
        'logiPat',
        'rrhelper',
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        'tohtml',
        'tutor',
      },
    },
  },
  debug = false,
})
