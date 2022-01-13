 local options = {
   backup = false,                          -- creates a backup file
   clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
   laststatus = 2,                      -- Always display the status line
   completeopt = { "menuone", "noselect" }, -- mostly just for cmp
   conceallevel = 0,                        -- so that `` is visible in markdown files
   hidden = true,                            -- Required to keep multiple buffers open multiple buffers
   fileencoding = "utf-8",                  -- the encoding written to a file
   hlsearch = false,                         -- highlight all matches on previous search pattern
   incsearch = true,                         -- Show resuls as you type a search
   ignorecase = true,                       -- ignore case in search patterns
   smartcase = true,                         -- Unless using a capital letter in search
   mouse = "a",                             -- allow the mouse to be used in neovim
   pumheight = 10,                          -- pop up menu height
   showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
   showtabline = 1,                         -- show tabs if 2 are open
   smartindent = true,                      -- make indenting smarter again
   splitbelow = true,                       -- force all horizontal splits to go below current window
   splitright = true,                       -- force all vertical splits to go to the right of current window
   swapfile = false,                        -- creates a swapfile
   termguicolors = true,                    -- set term gui colors (most terminals support this)
   updatetime = 600,                        -- faster completion (4000ms default)
   timeoutlen = 100,                        -- time to wait for a mapped sequence to complete (in milliseconds)
   undofile = false,                         -- enable persistent undo
   autochdir = false,
   writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
   expandtab = true,                        -- convert tabs to spaces
   shiftwidth = 4,                          -- the number of spaces inserted for each indentation
   tabstop = 4,                             -- insert 2 spaces for a tab
   softtabstop = 4,
   smarttab = false,
   cursorline = true,                       -- highlight the current line
   number = true,                           -- set numbered lines
   relativenumber = true,                   -- set relative numbered lines
   numberwidth = 4,                         -- set number column width to 2 {default 4}
   signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
   wrap = false,                            -- display lines as one long line
 }

vim.opt.shortmess:append "c" -- Get rid of "pattern not found" during completions
 
 for k, v in pairs(options) do
   vim.opt[k] = v
 end
 
 vim.cmd "set whichwrap+=<,>,[,],h,l"
 vim.cmd [[set iskeyword+=-]]
 vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work
