lua << EOF

require ('plugins')

require("telescope").setup {
  defaults = {
  },
  pickers = {
    find_files = {
        follow = true
    }
  },
  extensions = {
  }
}


EOF


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
nnoremap <C-p> <cmd>Telescope git_files<cr>
nnoremap <Leader>ff <cmd>Telescope find_files<cr>
nnoremap <Leader>fc <cmd>Telescope find_files cwd=~/.config<cr>
nnoremap <Leader>fg <cmd>Telescope live_grep<cr>
nnoremap <Leader>fb <cmd>Telescope buffers<cr>
nnoremap <Leader>fh <cmd>Telescope help_tags<cr>
