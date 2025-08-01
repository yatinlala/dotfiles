-- [[ Options ]]
-- `:help vim.opt`, `:help option-list`

vim.schedule(function()
    vim.opt.clipboard = "unnamedplus" -- use system clipboard
end)

vim.o.guifont = "JetBrainsMono Nerd Font:h15" -- text below applies for VimScript

-- vim.opt.tabstop = 4

-- Split below and to the right
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.undofile = true -- persistent undo

vim.opt.laststatus = 3
vim.opt.showmode = false -- hide -- INSERT --

vim.opt.path:append("**") -- :find searches subdirs

vim.opt.breakindent = true -- wrapped lines preserve indent level

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Sets how Neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`, `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.winblend = 5
vim.opt.winborder = "rounded"

-- Completion
vim.opt.completeopt = { "menuone", "noselect", "fuzzy" } -- mostly just for cmp
vim.opt.shortmess:append("c") -- Get rid of "pattern not found" during completions
vim.opt.pumheight = 8 -- number of items in completion menu

-- vim.opt.number = true -- set numbered lines
-- vim.opt.relativenumber = true -- set relative numbered lines
--
--
--
--
-- vim.opt.updatetime = 250 -- Decrease update time
-- vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time
--
--
-- vim.opt.expandtab = true -- convert tabs to spaces
--
--
-- vim.opt.inccommand = 'split' -- live substitution preview
--
-- vim.opt.cursorline = false -- Show which line your cursor is on
--
-- vim.opt.scrolloff = 0 -- Minimal number of screen lines to keep above and below the cursor.
--
--
-- -- vim.opt.smartindent = true -- make indenting smart
-- -- vim.opt.swapfile = false -- creates a swapfile
-- --
-- -- vim.opt.conceallevel = 2
-- --
-- -- vim.opt.numberwidth = 2 -- set min number column width to 2 {default 4}
-- -- vim.opt.wrap = false -- display lines as one long line
-- --
-- -- -- vim.opt.shortmess:append('I') -- Hide intro
-- --
-- --
-- --
-- -- if vim.g.neovide then
-- --     vim.g.neovide_fullscreen = false
-- --     vim.g.neovide_remember_window_size = false
-- --     vim.o.guifont = 'Liga SFMono Nerd Font:h11' -- text below applies for VimScript
-- --     vim.g.neovide_cursor_animation_length = 0.05
-- --     vim.g.neovide_cursor_trail_size = 0.3
-- --     vim.g.neovide_confirm_quit = true
-- --     vim.g.neovide_scale_factor = 1.0
-- --     local change_scale_factor = function(delta)
-- --         vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
-- --     end
-- --     vim.keymap.set('n', '<C-=>', function()
-- --         change_scale_factor(1.1)
-- --     end)
-- --     vim.keymap.set('n', '<C-->', function()
-- --         change_scale_factor(1 / 1.1)
-- --     end)
-- -- end
