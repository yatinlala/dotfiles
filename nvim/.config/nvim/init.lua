require("packer")
require("lsp-setup")
require("telescope-setup")
require("compe-setup")

-------------------- GENERAL SETTINGS --------------------

vim.cmd('syntax enable')                   -- Enables syntax highlighing
vim.cmd('set t_Co=256')                    -- Support 256 colors
vim.o.hlsearch = false                     --  No search highlighting
vim.o.mouse = 'a'                          -- Enable your mouse
vim.o.hidden = true                        -- Required to keep multiple buffers open multiple buffers
vim.o.ignorecase = true                    -- Case insensitive searching vim.o.smartcase = true                     -- Unless using a capital letter in search
-- vim.o.splitbelow = true                 -- Horizontal splits will automatically be below
vim.o.splitright = true                    -- Vertical splits will automatically be to the right
vim.o.conceallevel = 0                     -- So that I can see `` in markdown files
vim.o.tabstop = 4                          -- Insert 4 spaces for a tab
vim.o.softtabstop = 4          
vim.o.shiftwidth = 4                       -- Change the number of space characters inserted for indentation
vim.o.expandtab = true                     -- Convert tabs to spaces
--set nowrap                               -- Display long lines as just one line
vim.o.smartindent = true                   -- Makes indenting smart
vim.cmd('set noshowmode')                  -- We don't need to see things like -- INSERT -- anymore
vim.o.laststatus = 2                       -- Always display the status line
vim.cmd('set number relativenumber')       -- Line numbers
vim.cmd('set updatetime=300')              -- Faster completion
--set timeoutlen=500                       -- By default timeoutlen is 1000 ms
vim.cmd('set clipboard=unnamedplus')       -- Copy paste between vim and everything else
--vim.o.autochdir = true                     -- Your working directory will always be the same as your working directory
vim.cmd('autocmd BufEnter * silent! lcd %:p:h')
vim.o.incsearch = true                     -- Show resuls as you type a search
vim.cmd('set formatoptions-=cro')


-------------------- KEYBINDS --------------------

--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.api.nvim_set_keymap

-- Consistent Y
map('n', 'Y', 'y$', {noremap = true})
-- Centered searches
map('n', 'n', 'nzzzv', {noremap = true})
map('n', 'N', 'Nzzzv', {noremap = true})
-- Centered line cat
map('n', 'J', 'mzJ\'z', {noremap = true})
-- Undo break points
map('i', ',', ',<c-g>u', {noremap = true})
map('i', '.', '.<c-g>u', {noremap = true})
map('i', '(', '(<c-g>u', {noremap = true})
-- Move text
map('v', 'J', ':m \'>+1<CR>gv=gv', {noremap = true})
map('v', 'K', ':m \'>-2<CR>gv=gv', {noremap = true})
-- Smart(ish) compilation
map('n', '<leader>c',  ':w! \\| !comp <c-r>%<CR><CR>', {})
-- Enable spell checking
map('n', '<leader><leader>s', ':setlocal spell! spelllang=en_us<CR>', {})
-- Search and replace
map('n', '<leader>s', ':%s//g<Left><Left>', {})
-- Force save a sudoer file
map('c', 'w!!', 'w !sudo tee %', {})

-- Telescope
-- TODO C-p should git_files, if not in git dir then find_files in working dir
map('n', '<C-p>', ':lua require(\'telescope.builtin\').git_files()<CR>', {noremap = true})
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {noremap = true})
map('n', '<leader>fc', '<cmd>Telescope find_files cwd=~/.config<cr>', {noremap = true})
map('n', '<leader>en', ':lua require(\'telescope-setup\').search_dotfiles()<CR>', {noremap = true})
map('n', '<leader>fB', '<cmd>Telescope file_browser<cr>', {noremap = true})
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {noremap = true})
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', {noremap = true})
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', {noremap = true})

-- Sensible split movement
map('n', 'C-h>',  '<C-w>h', {})
map('n', '<C-j>',  '<C-w>j', {})
map('n', '<C-k>',  '<C-w>k', {})
map('n', '<C-l>',  '<C-w>l', {})

-- Other
map('n', '<leader>u', ':UndotreeToggle<CR>', {noremap = true})
map('n', '<leader>t', ':Vex<CR>', {noremap = true})

-- Fugitive
map('n', '<leader>gs',  ':G<CR>', {})
map('n', '<leader>gf',  ':diffget //3<CR>', {})
map('n', '<leader>gj',  ':diffget //2<CR>', {})

vim.cmd([[

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

augroup remember_folds
  autocmd!
  autocmd BufWinLeave *.vim mkview
  autocmd BufWinEnter *.vim silent! loadview
augroup END

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 25
]])
