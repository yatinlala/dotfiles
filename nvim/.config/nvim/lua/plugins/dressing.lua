-- Improve vim.ui
return {
    'stevearc/dressing.nvim',
    lazy = false,
    cond = not vim.ui.vscode,
    opts = {},
}
