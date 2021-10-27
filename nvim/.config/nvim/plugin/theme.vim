highlight Normal guibg=none
highlight Sneak guifg=black guibg=red ctermfg=black ctermbg=red

let s:enabled = 0

function! ToggleBg()
    if s:enabled
        set bg=dark
        let s:enabled = 0
    else
        set bg=light
        let s:enabled = 1
    endif
endfunction

map <Leader><Leader>c :call ToggleBg()<CR>

" set statusline=
" set statusline+=%<%F                                     "File+path
" set statusline+=\ \ \ \ %y                               "FileType
" set statusline+=\ \ \ \ %{''.(&fenc!=''?&fenc:&enc).''}  "Encoding
" set statusline+=\ %=\ %l,%c\ \                       "Rows and Columns
" set statusline+=%{fugitive#statusline()}    
" set statusline+=\ \ %m%r%w\ %P\ \                        "Modified? Readonly? Top/bot.

autocmd vimenter * colorscheme gruvbox8
set background=dark

lua << EOF
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
EOF
