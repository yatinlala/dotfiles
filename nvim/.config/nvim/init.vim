call plug#begin('~/.local/share/nvim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-commentary' 
Plug 'mbbill/undotree'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'hrsh7th/nvim-compe'

call plug#end()

" -------------------- KEYBINDS --------------------
let g:mapleader = " "

" smart(ish) compilation
map <Leader>c :w! \| !comp <c-r>%<CR><CR>

" Enable spell checking
map <Leader><Leader>s :setlocal spell! spelllang=en_us<CR>

" Search and replace
nnoremap S :%s//g<Left><Left>

" Sensible split movement
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nnoremap <Leader>u :UndotreeToggle<CR>
nnoremap <Leader>t :Vex<CR>
nnoremap <C-p> :Files %:p:h<CR>
