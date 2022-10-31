--[[ _ __   ___  _____   _(_)_ __ ___
    | '_ \ / _ \/ _ \ \ / / | '_ ` _ \
    | | | |  __/ (_) \ V /| | | | | | |
    |_| |_|\___|\___/ \_/ |_|_| |_| |_|  ]]


require 'plugin.config.impatient'
require 'options'
require 'globals'
require 'keymaps'
require 'autocmds'.setup()
require 'plugin'

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
