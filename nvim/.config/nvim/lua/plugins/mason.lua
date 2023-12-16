return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        'folke/neodev.nvim',
        { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    },
    lazy = false,
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup{
            ensure_installed = { "bashls", "clangd", "cmake", "cssls", "dockerls",
                "docker_compose_language_service", "gopls", "html", "jsonls",
                "tsserver", "lua_ls", "autotools_ls", "marksman",
                "ocamllsp", "pyright", "svelte"},
            automatic_installation = true,
        }


        local on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true }
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            -- vim.keymap.set({ "n", "i" }, "<S-k>", vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
            vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
            vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
            vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
            vim.keymap.set('n', 'gl', vim.diagnostic.open_float, bufopts)
            vim.keymap.set('n', '<space>d', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', '<space>lr', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<space>la', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            -- vim.keymap.set("n", "<space>lf", function()
            -- 	vim.lsp.buf.format({ async = true })
            -- end, bufopts)

            vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                {
                    virtual_text = false,
                    underline = true,
                    signs = true,
                })
            -- require('config.autocmds').lsp_hov_highlight()
            -- require("config.autocmds").lsp_hov_diagnostics()
        end
        require("mason-lspconfig").setup_handlers {
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.
            function(server_name)  -- default handler (optional)
                require("lspconfig")[server_name].setup {
                    on_attach = on_attach,
                }
            end,
            -- Next, you can provide a dedicated handler for specific servers.
            -- For example, a handler override for the `rust_analyzer`:
            ["lua_ls"] = function()
                require('lspconfig').lua_ls.setup({
                    on_attach = on_attach,
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { 'vim', 'awesome', 'client' },
                            },
                        },
                    },
                })
            end

        }
    end,

}
