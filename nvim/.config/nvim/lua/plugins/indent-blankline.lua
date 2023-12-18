return {
    "lukas-reineke/indent-blankline.nvim",
    event = 'BufWinEnter',
    main = "ibl",
    cond = not vim.g.vscode,
    opts = {
        indent = { char = '┆' },
        scope = { enabled = false },

    }
}
