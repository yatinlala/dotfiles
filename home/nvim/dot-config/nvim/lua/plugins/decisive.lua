vim.api.nvim_create_autocmd("FileType", {
    pattern = "csv",
    callback = function()
        vim.pack.add({ "https://github.com/emmanueltouzery/decisive.nvim" })

        vim.keymap.set("n", "<leader>cca", ":lua require('decisive').align_csv({})<cr>", { desc = "align CSV", silent = true })
        vim.keymap.set("n", "<leader>ccA", ":lua require('decisive').align_csv_clear({})<cr>", { desc = "align CSV clear", silent = true })
        vim.keymap.set("n", "[c", ":lua require('decisive').align_csv_prev_col()<cr>", { desc = "align CSV prev col", silent = true })
        vim.keymap.set("n", "]c", ":lua require('decisive').align_csv_next_col()<cr>", { desc = "align CSV next col", silent = true })

        -- setup text objects (optional)
        require("decisive").setup({})
    end,
})
