-- Don't show any numbers inside terminals
vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]

-- Don't show status line on certain windows
vim.cmd [[ autocmd BufEnter,BufRead,BufWinEnter,FileType,WinEnter * lua require("core.utils").hide_statusline() ]]
