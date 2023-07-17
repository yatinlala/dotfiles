vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.opt.clipboard = 'unnamedplus' -- use system clipboard
vim.opt.completeopt = { 'menuone', 'noselect' } -- mostly just for cmp
vim.opt.spell = false
vim.opt.ignorecase = true -- ignore search case
vim.opt.smartcase = true -- Unless using a capital letter in search
vim.opt.mouse = 'a' -- allow the mouse to be used in neovim
vim.opt.showmode = false -- hide -- INSERT --
vim.opt.showtabline = 1 -- show tabs if 2 are open
vim.opt.smartindent = true -- make indenting smart
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false -- creates a swapfile
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.o.tabstop = 4
vim.o.conceallevel = 2
vim.o.pumheight = 15

-- vim.opt.updatetime = 100  -- faster completion (4000ms default)
-- vim.opt.timeoutlen = 100  -- time to wait for a mapped sequence to complete (in milliseconds)
-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

vim.opt.undofile = true -- persistent undo
vim.opt.backup = false -- creates a backup file
vim.opt.writebackup = false -- make backup before overwriting
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.smarttab = true
vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.numberwidth = 2 -- set min number column width to 2 {default 4}
vim.opt.signcolumn = 'yes' -- always show the sign column
vim.opt.wrap = false -- display lines as one long line
vim.o.breakindent = true -- Wrapped lines preserve indent level
vim.opt.shortmess:append 'c' -- Get rid of "pattern not found" during completions
vim.opt.shortmess:append 'I' -- Hide intro
vim.opt.laststatus = 3 -- global statusline
