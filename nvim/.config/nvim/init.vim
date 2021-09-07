lua << EOF

require("packer")
--require("lualine-setup")
require("telescope-setup")
require("compe-setup")

-------------------- GENERAL SETTINGS --------------------

vim.cmd('syntax enable')                   -- Enables syntax highlighing
vim.cmd('set t_Co=256')                    -- Support 256 colors
vim.o.hlsearch = false                     --  No search highlighting
vim.o.mouse = 'a'                          -- Enable your mouse
vim.o.hidden = true                        -- Required to keep multiple buffers open multiple buffers
vim.o.ignorecase = true                    -- Case insensitive searching
vim.o.smartcase = true                     -- Unless using a capital letter in search
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
--set updatetime=300                       -- Faster completion
--set timeoutlen=500                       -- By default timeoutlen is 1000 ms
vim.cmd('set clipboard=unnamedplus')       -- Copy paste between vim and everything else
--vim.o.autochdir = true                     -- Your working directory will always be the same as your working directory
vim.cmd('autocmd BufEnter * silent! lcd %:p:h')
vim.o.incsearch = true                     -- Show resuls as you type a search
vim.cmd('set formatoptions-=cro')
--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

EOF

" You can't stop me
cmap w!! w !sudo tee %

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


" -------------------- KEYBINDS --------------------

" Consistent Y
nnoremap Y y$
" Centered searches
nnoremap n nzzzv
nnoremap N Nzzzv
" Centered line cat
nnoremap J mzJ'z
" Undo break Points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ( (<c-g>u
" Move text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" Format
nmap Q gq
" smart(ish) compilation
map <leader>c :w! \| !comp <c-r>%<CR><CR>
" Enable spell checking
map <leader><leader>s :setlocal spell! spelllang=en_us<CR>
" Search and replace
nnoremap S :%s//g<Left><Left>
" Sensible split movement
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>t :Vex<CR>

" Find files using Telescope command-line sugar.
" TODO C-p should git_files, if not in git dir then find_files in working dir
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <leader>ff <cmd>Telescope find_files cwd=~<cr>
nnoremap <leader>fc <cmd>Telescope find_files cwd=~/.config<cr>
nnoremap <leader>fn :lua require('telescope-setup').search_dotfiles()<CR>
nnoremap <leader>fb <cmd>Telescope file_browser<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" FUGITIVE
nmap <leader>gs :G<cr>
nmap <leader>gf :diffget //3<cr>
nmap <leader>gj :diffget //2<cr>
