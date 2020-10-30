" Basic Settings
let mapleader = " "
set t_Co=256
set mouse=a
set ignorecase
set smartcase
set number relativenumber
set clipboard=unnamedplus

call plug#begin('~/.local/share/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'vimwiki/vimwiki'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-commentary'

call plug#end()

" set gruv theme
autocmd vimenter * colorscheme gruvbox
set bg=dark

" pandoc compilation
map <Leader>p :w! \| !comp <c-r>%<CR><CR>

" Enable spell checking
map <Leader>S :setlocal spell! spelllang=en_us<CR>

" Save and quit macro 
map <Leader>s :wq<CR>

" Quit Macro
map <Leader>q :q!<CR>

" Tab Settings
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Autocompletion
set wildmode=longest,list,full

" Disable auto commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Better split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Better splitting
set splitbelow splitright
