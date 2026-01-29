vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    -- "https://github.com/mason-org/mason-lspconfig.nvim",
})

-- vim.keymap.set("n", "<leader>al", function()
--     vim.lsp.enable("copilot")
-- end, { desc = "enable copilot lsp" })

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
    callback = function(event)
        vim.opt.signcolumn = "yes"
        local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- -- LSP AUTOCOMPLETION
        -- local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- if client:supports_method('textDocument/completion') then
        --     vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
        -- end

        map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("gl", vim.diagnostic.open_float, "Open Float", { "n", "x" })

        -- vim.diagnostic.config({ virtual_text = true })
        -- vim.diagnostic.config({ virtual_lines = { current_line = true } })

        local function ToggleVirtualText()
            local current_config = vim.diagnostic.config()

            if current_config.virtual_text then
                vim.diagnostic.config({ virtual_text = false })
            else
                vim.diagnostic.config({ virtual_text = true })
            end
        end
        map("<leader>v", ToggleVirtualText, "Toggle Lsp Virtual Text")

        -- vim.api.nvim_create_autocmd({ 'InsertCharPre', 'CursorMovedI', 'CursorHold', 'CursorHoldI' }, {
        --     -- check if the character before the cursor is `{` or it is all spaces
        --     group = vim.api.nvim_create_augroup('lsp_signature', { clear = true }),
        --     callback = function()
        --         vim.lsp.buf.signature_help()
        --     end, -- debounce 500ms
        -- })
        -- vim.api.nvim_create_autocmd("TextChangedI", {
        --     pattern = "*",
        --     callback = function()
        --         local line = vim.api.nvim_get_current_line()
        --         local col = vim.fn.col('.') - 1
        --         local char = line:sub(col, col)
        --         if char == '(' or char == ',' then
        --             vim.lsp.buf.signature_help()
        --         end
        --     end
        -- })

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>li", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[L]sp Toggle [I]nlay Hints")
        end
    end,
})

vim.lsp.on_type_formatting.enable()

require("mason").setup()

-- require("mason-lspconfig").setup({
--     ensure_installed = { "lua_ls" },
--     automatic_enable = true,
-- })

-- -- Names must be Mason package names
-- local ensure_installed = {
--     -- "clangd",
--     -- "lua-language-server",
--     "prettierd",
-- }
--
-- -- https://www.reddit.com/r/neovim/comments/1p1y73n/automatically_downloading_and_installing_lsps/
-- local installed_package_names = require("mason-registry").get_installed_package_names()
-- for _, v in ipairs(ensure_installed) do
--     if not vim.tbl_contains(installed_package_names, v) then
--         vim.cmd(":MasonInstall " .. v)
--     end
-- end

local installed_packages = require("mason-registry").get_installed_packages()
local installed_lsp_names = vim.iter(installed_packages):fold({}, function(acc, pack)
    table.insert(acc, pack.spec.neovim and pack.spec.neovim.lspconfig)
    return acc
end)

vim.lsp.enable(installed_lsp_names)

-- manually installed
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")
