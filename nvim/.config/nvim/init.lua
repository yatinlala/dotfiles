pcall(function()
    vim.loader.enable()
end)

-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('config.lazy')

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.commands')

vim.cmd([[ set statusline=%!v:lua.require'statusline'.line() ]])
