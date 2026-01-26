vim.opt.smartindent = true

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
        vim.lsp.inlay_hint.enable(true)
    end,
})
