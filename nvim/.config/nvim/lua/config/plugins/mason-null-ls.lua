return {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        'williamboman/mason.nvim',
        'jose-elias-alvarez/null-ls.nvim',
    },
    config = function()
        -- require 'your.null-ls.config' -- require your null-ls config here (example below)
        -- local null_ls = require 'null-ls'
        -- null_ls.setup {
        --   sources = {
        --     null_ls.builtins.formatting.stylua,
        --     null_ls.builtins.formatting.shfmt,
        --     null_ls.builtins.diagnostics.eslint,
        --     null_ls.builtins.completion.spell,
        --     null_ls.builtins.formatting.ocamlformat,
        --     null_ls.builtins.formatting.black,
        --   },
        -- }
        require('mason-null-ls').setup({
            handlers = {},
        })
    end,
}
