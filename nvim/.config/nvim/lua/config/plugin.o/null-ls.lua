local M = {
  'jose-elias-alvarez/null-ls.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
  },
  event = 'VeryLazy', -- kills splash, CursorMove fixed (haven't completely confirmed)
  enabled = false,
}

function M.config()
  local null_ls = require 'null-ls'
  null_ls.setup {
    sources = {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.shfmt,
      null_ls.builtins.diagnostics.eslint,
      null_ls.builtins.completion.spell,
      null_ls.builtins.formatting.ocamlformat,
      null_ls.builtins.formatting.black,
    },
  }
end

return M
