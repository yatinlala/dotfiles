-- exit terminal mode
vim.keymap.set("t", "JK", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")

vim.keymap.set("n", "<leader>t", "<cmd>term<CR>i", { desc = "Open terminal" })
vim.keymap.set("n", "<leader>e", "<cmd>term lf<CR>i", { desc = "Open Lf" })
-- vim.keymap.set("n", "<leader>st", function()
--     vim.cmd.vnew()
--     vim.cmd.term()
--     vim.cmd.wincmd("J")
--     vim.api.nvim_win_set_height(0, 15)
--     vim.cmd.startinsert()
-- end, { desc = "Open Lf" })

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "term://*",
    desc = "insert in terminals",
    group = vim.api.nvim_create_augroup("insert_term", { clear = true }),
    callback = function()
        print("hello")
        vim.cmd.startinsert()
    end,
})
-- vim.cmd('autocmd BufEnter term://* startinsert')

-- vim.cmd [[ autocmd TermClose * execute 'bdelete! ' . expand('<abuf>') ]]
