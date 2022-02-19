require('hop').setup({
  create_hl_autocmd = false
})

vim.cmd[[
  highlight HopNextKey  guifg=#b8bb26 gui=bold ctermfg=45 cterm=bold
  highlight HopNextKey1 guifg=#b8bb26 gui=bold ctermfg=45 cterm=bold
  highlight HopNextKey2 guifg=#b8bb26 ctermfg=45
  highlight HopUnmatched guifg=#7c6f64 guibg=bg guisp=#666666 ctermfg=242
  highlight link HopCursor Cursor
  augroup HopInitHighlight
  autocmd!
  autocmd ColorScheme * lua require'hop.highlight'.insert_highlights()
  augroup end
  ]]
