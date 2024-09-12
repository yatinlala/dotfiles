return {
    {
        'neovim/nvim-lspconfig',
        -- VeryLazy won't work b/c LSPs rely on FileType autocmd
        event = { 'BufReadPost', 'BufNewFile' },
        cmd = { 'LspInfo' },

        dependencies = {
            { 'williamboman/mason.nvim', opts = {}, cmd = { 'Mason', 'MasonInstall', 'MasonLog', 'MasonUninstall', 'MasonUninstallAll', 'MasonUpdate' } },
            { 'williamboman/mason-lspconfig.nvim', dependencies = { 'williamboman/mason.nvim' } },
        },
        config = function()
            require('mason-lspconfig').setup({ ensure_installed = { 'lua_ls' } })

            require('mason-lspconfig').setup_handlers({
                -- default handler
                function(server_name) -- default handler (optional)
                    require('lspconfig')[server_name].setup({})
                end,
                -- dedicated handler
                -- ['lua_ls'] = function()
                --     require('lua_ls').setup({})
                -- end,
                -- -- Next, you can provide a dedicated handler for specific servers.
                -- -- For example, a handler override for the `rust_analyzer`:
                -- ['rust_analyzer'] = function()
                --     require('rust-tools').setup({})
                -- end,
            })
        end,
    },
}
