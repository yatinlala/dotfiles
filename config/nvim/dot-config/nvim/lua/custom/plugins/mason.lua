return {
    {
        'neovim/nvim-lspconfig',
        -- VeryLazy won't work b/c LSPs rely on FileType autocmd
        event = { 'BufReadPre', 'BufNewFile' },
        cmd = { 'LspInfo' },

        dependencies = {
            {
                'williamboman/mason.nvim',
                opts = {},
                cmd = {
                    'Mason',
                    'MasonInstall',
                    'MasonLog',
                    'MasonUninstall',
                    'MasonUninstallAll',
                    'MasonUpdate'
                }
            },
            { 'williamboman/mason-lspconfig.nvim', dependencies = { 'williamboman/mason.nvim' } },
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
                callback = function(event)
                    vim.opt.signcolumn = 'yes'
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    -- LSP AUTOCOMPLETION
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client:supports_method('textDocument/completion') then
                        vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
                    end

                    -- - 'omnifunc' is set to |vim.lsp.omnifunc()|, use |i_CTRL-X_CTRL-O| to trigger
                    --   completion.
                    -- - 'tagfunc' is set to |vim.lsp.tagfunc()|. This enables features like
                    --   go-to-definition, |:tjump|, and keymaps like |CTRL-]|, |CTRL-W_]|,
                    --   |CTRL-W_}| to utilize the language server.
                    -- - 'formatexpr' is set to |vim.lsp.formatexpr()|, so you can format lines via
                    --   |gq| if the language server supports it.
                    --   - To opt out of this use |gw| instead of gq, or clear 'formatexpr' on |LspAttach|.
                    -- - |K| is mapped to |vim.lsp.buf.hover()| unless |'keywordprg'| is customized or
                    --   a custom keymap for `K` exists.

                    -- *grr* *gra* *grn* *gri* *i_CTRL-S*
                    -- Some keymaps are created unconditionally when Nvim starts:
                    -- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
                    -- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
                    -- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
                    -- - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
                    -- - "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
                    -- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
                    --
                    -- If not wanted, these keymaps can be removed at any time using
                    -- |vim.keymap.del()| or |:unmap| (see also |gr-default|).

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                    -- THIS IS C-]
                    map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition') -- INSTEAD I GLOBALLY REMAP gd to C-].

                    -- Find references for the word under your cursor.
                    -- THIS IS GRR by default
                    -- map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    -- map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    -- THIS IS GRN BY DEFAULT!
                    -- map('<leader>ln', vim.lsp.buf.rename, '[L]sp Re[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    -- THIS IS GRA BY DEFAULT!
                    -- map('<leader>lc', vim.lsp.buf.code_action, '[L]sp [C]ode Action', { 'n', 'x' })

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    -- Open diagnostic float
                    map('gl', vim.diagnostic.open_float, 'Open Float', { 'n', 'x' })

                    vim.diagnostic.config({ virtual_lines = { current_line = true } })

                    local function ToggleVirtualText()
                        -- Get the current diagnostics configuration
                        local current_config = vim.diagnostic.config()

                        -- Toggle the virtual_text setting
                        if current_config.virtual_text then
                            vim.diagnostic.config({ virtual_text = false })
                        else
                            vim.diagnostic.config({ virtual_text = true })
                        end
                    end
                    map('<leader>lv', ToggleVirtualText, 'Toggle [L]sp [V]irtual Text')

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        local highlight_augroup = vim.api.nvim_create_augroup('lsp_highlight', { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('lsp_detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = 'lsp_highlight', buffer = event2.buf })
                            end,
                        })
                    end

                    -- The following code creates a keymap to toggle inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map('<leader>li', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, '[L]sp Toggle [I]nlay Hints')
                    end
                end,
            })

            -- local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            require('mason-lspconfig').setup({ ensure_installed = { 'lua_ls' } })

            require('mason-lspconfig').setup_handlers({
                -- default handler
                function(server_name) -- default handler (optional)
                    require('lspconfig')[server_name].setup({})
                end,
                -- dedicated handler
                ['harper_ls'] = function()
                    require('lspconfig').harper_ls.setup({ autostart = false })
                end,
            })
        end,
    },
}
