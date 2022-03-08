local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  vim.notify("lspconfig not found!")
  return
end

require "plugins.configs.lsp.lsp-installer"
require("plugins.configs.lsp.handlers").setup()
--require "user.lsp.null-ls"

vim.cmd('autocmd CursorHold * lua vim.diagnostic.open_float()')
vim.cmd('autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()')

vim.cmd [[
augroup locallist
    autocmd!
    autocmd BufWrite,BufEnter,InsertLeave * :lua vim.diagnostic.setloclist({open = false})
augroup END
]]
