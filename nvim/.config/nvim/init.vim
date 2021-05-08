call plug#begin('~/.local/share/nvim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'vimwiki/vimwiki'
Plug 'dhruvasagar/vim-table-mode' 
Plug 'tpope/vim-commentary' 
Plug 'mbbill/undotree'
Plug 'tools-life/taskwiki'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

call plug#end()


" -------------------- BASIC SETTINGS --------------------
set t_Co=256 
set mouse=a
" set scrolloff=4
set number relativenumber
set noerrorbells
set clipboard=unnamedplus
set hidden
set nohlsearch
set incsearch
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set wildmode=longest,list,full
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
set splitbelow splitright
let mapleader = " "

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 25

" -------------------- KEYBINDS --------------------
" pandoc compilation
map <Leader><Leader>c :w! \| !comp <c-r>%<CR><CR>

" Enable spell checking
map <Leader><Leader>s :setlocal spell! spelllang=en_us<CR>

" Search and replace
nnoremap S :%s//g<Left><Left>

" Sensible splits
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nnoremap <Leader>u :UndotreeToggle<CR>
nnoremap <Leader>nt :Vex<CR>
nnoremap <C-p> :Files %:p:h<CR>
nnoremap <Leader>r :Rg<CR>
