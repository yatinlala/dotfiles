" call plug#end()
" lua << EOF
" EOF

lua require('plugins')


" -------------------- KEYBINDS --------------------
let g:mapleader = " "

"Make  Y work in a consistent way
nnoremap Y y$

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

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
