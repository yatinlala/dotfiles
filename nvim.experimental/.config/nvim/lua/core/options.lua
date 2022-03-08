local opt = vim.opt
local g = vim.g

opt.title = true
opt.clipboard = "unnamedplus"               -- use system clipboard
opt.cursorline = false                      -- highlight the current line

-- Indentline
opt.expandtab = true                        -- convert tabs to spaces
opt.shiftwidth = 2                          -- the number of spaces inserted for each indentation
opt.smartindent = true                      -- make indenting smart

-- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
opt.fillchars = { eob = " " }

opt.hidden = true                           -- Required to keep multiple buffers open multiple buffers
opt.ignorecase = true                       -- ignore case in search patterns
opt.smartcase = true                         -- Unless using a capital letter in search
opt.mouse = "a"                             -- allow the mouse to be used in neovim

-- Numbers
opt.number = true                           -- set numbered lines
opt.relativenumber = true                   -- set relative numbered lines
opt.numberwidth = 2                         -- set min number column width to 2 {default 4}
opt.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"                      -- always show the sign column
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 8                             -- insert _ spaces for a tab
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = false

opt.laststatus = 2                          -- Always display the status line
opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
opt.conceallevel = 0                        -- don't conceal markups
opt.hlsearch = false                        -- highlight all matches on previous search pattern
opt.incsearch = true                        -- Show resuls as you type a search
opt.swapfile = false                        -- creates a swapfile
opt.smarttab = true
opt.wrap = false                            -- display lines as one long line
opt.shortmess:append "c" -- Get rid of "pattern not found" during completions

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

g.mapleader = " "

-- disable some builtin vim plugins
local disabled_built_ins = {
   "2html_plugin",
   "getscript",
   "getscriptPlugin",
   "gzip",
   "logipat",
   "netrw",
   "netrwPlugin",
   "netrwSettings",
   "netrwFileHandlers",
   "matchit",
   "tar",
   "tarPlugin",
   "rrhelper",
   "spellfile_plugin",
   "vimball",
   "vimballPlugin",
   "zip",
   "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
   g["loaded_" .. plugin] = 1
end

--Defer loading shada until after startup_
vim.schedule(function()
   vim.cmd [[ silent! rsh ]]
end)

vim.cmd [[
    set whichwrap+=<,>,[,],h,l
    set iskeyword+=-
    set path +=**
    autocmd BufEnter * set formatoptions-=cro
]]
