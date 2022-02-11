vim.opt.clipboard = "unnamedplus"               -- use system clipboard
vim.opt.laststatus = 2                          -- Always display the status line
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0                        -- don't conceal markups
vim.opt.hidden = true                           -- Required to keep multiple buffers open multiple buffers
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = false                        -- highlight all matches on previous search pattern
vim.opt.incsearch = true                        -- Show resuls as you type a search
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.smartcase = true                         -- Unless using a capital letter in search
vim.opt.mouse = "a"                             -- allow the mouse to be used in neovim
vim.opt.showmode = false                        -- hide -- INSERT --
vim.opt.showtabline = 1                         -- show tabs if 2 are open
vim.opt.smartindent = true                      -- make indenting smart
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.updatetime = 600                        -- faster completion (4000ms default)
vim.opt.timeoutlen = 100                        -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = false                        -- persistent undo
vim.opt.autochdir = false                       -- change cwd on buffer open and buffer switch
vim.opt.backup = false                          -- creates a backup file
vim.opt.writebackup = false                     -- make backup before overwriting
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.shiftwidth = 4                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4                             -- insert 2 spaces for a tab
vim.opt.softtabstop = 0
vim.opt.smarttab = true
vim.opt.cursorline = false                      -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.relativenumber = true                   -- set relative numbered lines
vim.opt.numberwidth = 2                         -- set min number column width to 2 {default 4}
vim.opt.signcolumn = "yes"                      -- always show the sign column
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.shortmess:append "c" -- Get rid of "pattern not found" during completions


vim.cmd [[
    set whichwrap+=<,>,[,],h,l
    set iskeyword+=-
    autocmd BufEnter * set formatoptions-=cro
    autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"
]]
