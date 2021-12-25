" Set wiki path
let g:vimwiki_list = [{'path': '~/documents/wiki/'}]

" :Diary goes to index and generates links

command! Diary VimwikiDiaryIndex
augroup vimwikigroup
    autocmd!
    " automatically update links on read diary
    autocmd BufRead,BufNewFile diary.wiki VimwikiDiaryGenerateLinks
augroup end
