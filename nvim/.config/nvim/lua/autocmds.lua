vim.cmd[[
augroup remember_folds
  autocmd!
  au BufWinLeave ?* mkview 1
  au BufWinEnter ?* silent! loadview 1
augroup END]]

vim.api.nvim_create_autocmd("BufEnter", { callback = function() vim.opt.formatoptions = vim.opt.formatoptions - { "c","r","o" } end, })
