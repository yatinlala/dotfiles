call plug#begin('~/.local/share/nvim/plugged')
Plug 'gruvbox-community/gruvbox'
Plug 'vimwiki/vimwiki'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-commentary'
Plug 'liuchengxu/vim-which-key'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'

call plug#end()


" -------------------- BASIC SETTINGS --------------------
let mapleader = " "
set t_Co=256
set mouse=a
set ignorecase
set lazyredraw
set smartcase
set number relativenumber
set clipboard=unnamedplus
set nohlsearch

" -------------------- MACROS --------------------
" pandoc compilation
map <Leader>c :w! \| !comp <c-r>%<CR><CR>

" Enable spell checking
map <Leader><Leader>s :setlocal spell! spelllang=en_us<CR>


" Search and replace
nnoremap S :%s//g<Left><Left>

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


" -------------------- PLUGIN CONFIGS --------------------

"Source stuff
source $HOME/.config/nvim/fzf.vim
source $HOME/.config/nvim/which-key.vim

" Markdown-style table corners
let g:table_mode_corner='|'

" set gruv theme
autocmd vimenter * colorscheme gruvbox
set bg=dark

" Change vimwiki default location
let g:vimwiki_list = [{'path': '~/documents/wiki/'}]

" Transparency
autocmd vimenter * hi Normal ctermbg=NONE
