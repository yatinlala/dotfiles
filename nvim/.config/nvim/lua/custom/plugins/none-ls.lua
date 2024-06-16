return {
    'jay-babu/mason-null-ls.nvim',
    event = 'VeryLazy',
    dependencies = {
        'williamboman/mason.nvim',
        'nvimtools/none-ls.nvim',
    },
    config = function()
        require('mason').setup()
        require('mason-null-ls').setup({
            ensure_installed = {
                'gofmt',
                'golines',
                'goimports-reviser',
                'stylua',
                'clang-format',
            },
            automatic_installation = false,
            handlers = {},
        })
        require('null-ls').setup({
            sources = {
                -- Anything not supported by mason.
            },
        })
    end,
}
