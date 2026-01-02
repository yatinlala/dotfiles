-- [[ Options ]]
-- `:help vim.opt`, `:help option-list`

vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        vim.o.clipboard = "unnamedplus"
    end,
})

vim.o.guifont = "JetBrainsMono Nerd Font:h18" -- text below applies for VimScript

-- vim.opt.tabstop = 4

vim.o.title = true

-- Split below and to the right
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.undofile = true -- persistent undo

vim.o.laststatus = 3
vim.o.showmode = false -- hide -- INSERT --
-- vim.o.cmdheight = 0

vim.opt.path:append("**") -- :find searches subdirs

vim.o.breakindent = true -- wrapped lines preserve indent level

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- :help 'list' :help, 'listchars'
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.o.winblend = 5
-- vim.o.winborder = "single"
-- vim.o.pumborder = "single"

vim.opt.number = true
vim.opt.relativenumber = true

vim.o.confirm = true

vim.o.exrc = true
-- vim.o.secure = true

vim.opt.conceallevel = 1

-- Completion
vim.opt.pumheight = 8 -- number of items in completion menu
vim.opt.completeopt = { "menuone", "noselect", "fuzzy", "popup" }
vim.opt.shortmess:append("c") -- Get rid of "pattern not found" during completions

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
