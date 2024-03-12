-- See `:help vim.opt`
--  For more options, you can see `:help option-list`

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.clipboard = 'unnamedplus' -- use system clipboard
vim.opt.mouse = 'a' -- allow the mouse to be used in neovim
vim.opt.showmode = false -- hide -- INSERT --
vim.opt.smartindent = true -- make indenting smart
vim.opt.swapfile = false -- creates a swapfile
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)

vim.opt.conceallevel = 2

vim.opt.inccommand = 'split' -- live substitution preview

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.undofile = true -- persistent undo
vim.opt.writebackup = false -- make backup before overwriting

vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.tabstop = 4 -- number of spaces that <tab> counts for

vim.opt.ignorecase = true -- ignore search case
vim.opt.smartcase = true -- Unless using a capital letter in search

vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = true -- set relative numbered lines

vim.opt.numberwidth = 2 -- set min number column width to 2 {default 4}
vim.opt.signcolumn = 'yes' -- always show the sign column
vim.opt.wrap = false -- display lines as one long line
vim.opt.breakindent = true -- Wrapped lines preserve indent level
vim.opt.laststatus = 3 -- global statusline


-- vim.opt.shortmess:append('I') -- Hide intro

-- Completion
vim.opt.completeopt = { 'menuone', 'noselect' } -- mostly just for cmp
vim.opt.shortmess:append('c') -- Get rid of "pattern not found" during completions
vim.opt.pumheight = 15 -- number of items in completion menu

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

if vim.g.neovide then
    vim.g.neovide_fullscreen = false
    vim.g.neovide_remember_window_size = false
    vim.o.guifont = 'Liga SFMono Nerd Font:h11' -- text below applies for VimScript
    vim.g.neovide_cursor_animation_length = 0.05
    vim.g.neovide_cursor_trail_size = 0.3
    vim.g.neovide_confirm_quit = true
    vim.g.neovide_scale_factor = 1.0
    local change_scale_factor = function(delta)
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    end
    vim.keymap.set('n', '<C-=>', function()
        change_scale_factor(1.1)
    end)
    vim.keymap.set('n', '<C-->', function()
        change_scale_factor(1 / 1.1)
    end)
end


