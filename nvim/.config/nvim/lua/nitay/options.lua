vim.opt.backup = false                          -- creates a backup file
vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
vim.opt.laststatus = 2                      -- Always display the status line
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
vim.opt.hidden = true                            -- Required to keep multiple buffers open multiple buffers
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = false                         -- highlight all matches on previous search pattern
vim.opt.incsearch = true                         -- Show resuls as you type a search
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.smartcase = true                         -- Unless using a capital letter in search
vim.opt.mouse = "a"                             -- allow the mouse to be used in neovim
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.showmode = false                        -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 1                         -- show tabs if 2 are open
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.updatetime = 600                        -- faster completion (4000ms default)
vim.opt.timeoutlen = 100                        -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = false                         -- enable persistent undo
vim.opt.autochdir = false
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.shiftwidth = 4                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4                             -- insert 2 spaces for a tab
vim.opt.softtabstop = 4
vim.opt.smarttab = false
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.relativenumber = true                   -- set relative numbered lines
vim.opt.numberwidth = 4                         -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.shortmess:append "c" -- Get rid of "pattern not found" during completions


vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[autocmd BufEnter * set formatoptions-=cro]]