return {
    "emmanueltouzery/decisive.nvim",
    ft = "csv",
    enabled = false,
    config = function()
        vim.keymap.set("n", "<leader>cca", function()
            require("decisive").align_csv({})
        end, { desc = "align CSV", silent = true })
        vim.keymap.set("n", "<leader>ccA", function()
            require("decisive").align_csv_clear({})
        end, { desc = "align CSV clear", silent = true })
        vim.keymap.set("n", "[c", function()
            require("decisive").align_csv_prev_col()
        end, { desc = "align CSV prev col", silent = true })
        vim.keymap.set("n", "]c", function()
            require("decisive").align_csv_next_col()
        end, { desc = "align CSV next col", silent = true })

        -- setup text objects (optional)
        require("decisive").setup({})
    end,
}
