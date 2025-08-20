vim.pack.add({ "https://github.com/catgoose/nvim-colorizer.lua" })

vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function()
        require("colorizer").setup()

        vim.keymap.set("n", "<leader>C", "<cmd>ColorizerToggle<CR>", { desc = "Toggle Colorizer" })
    end,
})
