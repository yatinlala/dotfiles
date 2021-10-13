autocmd vimenter * colorscheme gruvbox8
set background=dark
highlight Normal guibg=none

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

set statusline=
set statusline+=%<%F                                     "File+path
set statusline+=\ \ \ \ %y                               "FileType
set statusline+=\ \ \ \ %{''.(&fenc!=''?&fenc:&enc).''}  "Encoding
set statusline+=\ %=\ %l,%c\ \                       "Rows and Columns
set statusline+=%{fugitive#statusline()}    
set statusline+=\ \ %m%r%w\ %P\ \                        "Modified? Readonly? Top/bot.
