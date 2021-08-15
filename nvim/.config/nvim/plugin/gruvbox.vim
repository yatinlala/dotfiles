autocmd vimenter * colorscheme gruvbox8_soft
set bg=dark
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
