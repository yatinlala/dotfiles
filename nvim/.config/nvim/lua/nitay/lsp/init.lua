local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  vim.notify("lspconfig not found!")
  return
end

require "nitay.lsp.lsp-installer"
require("nitay.lsp.handlers").setup()
--require "user.lsp.null-ls"
--
vim.cmd('autocmd CursorHold * lua vim.diagnostic.open_float()')
vim.cmd('autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()')
