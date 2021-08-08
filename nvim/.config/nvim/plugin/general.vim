syntax enable                           " Enables syntax highlighing
set ignorecase
set smartcase
set hidden                              " Required to keep multiple buffers open multiple buffers
"set nowrap                              " Display long lines as just one line
set pumheight=10                        " Makes popup menu smaller set cmdheight=2                         " More space for displaying messages
"set iskeyword+=-                      	" treat dash separated words as a word text object"
set mouse=a                             " Enable your mouse
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set t_Co=256                            " Support 256 colors
set conceallevel=0                      " So that I can see `` in markdown files
set tabstop=4 softtabstop=4             " Insert 4 spaces for a tab
set shiftwidth=4                        " Change the number of space characters inserted for indentation
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set autoindent                          " Good auto indent
"set laststatus=0                        " Always display the status line
set number relativenumber               " Line numbers
set background=dark                     " tell vim what the background color looks like
"set updatetime=300                      " Faster completion
"set timeoutlen=500                      " By default timeoutlen is 1000 ms
set formatoptions-=cro                  " Stop newline continution of comments
set clipboard=unnamedplus               " Copy paste between vim and everything else
"set autochdir                           " Your working directory will always be the same as your working directory
set wildmode=longest,list,full

" You can't stop me
cmap w!! w !sudo tee %

" set scrolloff=4
set noerrorbells
set nohlsearch
set incsearch
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 25