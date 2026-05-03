if true then
    return
end
vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

vim.keymap.set("n", "<leader>f", "<cmd>FzfLua files<CR>", { desc = "Pick [F]iles" })
vim.keymap.set("n", "<leader>G", "<cmd>FzfLua live_grep<CR>", { desc = "Live [G]rep" })
vim.keymap.set("n", "<leader>h", "<cmd>FzfLua help_tags<CR>", { desc = "Pick [H]elp" })
