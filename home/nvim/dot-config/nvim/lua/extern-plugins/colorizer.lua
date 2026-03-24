-- vim.api.nvim_create_autocmd("BufReadPre", {
--     callback = function()
--
--         vim.keymap.set("n", "<leader>C", "<cmd>ColorizerToggle<CR>", { desc = "Toggle Colorizer" })
--     end,
-- })

-- require("plugins.util").packadd({ })

vim.schedule(function()
    vim.pack.add({ "https://github.com/catgoose/nvim-colorizer.lua" })
    require("colorizer").setup()
    vim.keymap.set("n", "<leader>C", "<cmd>ColorizerToggle<CR>", { desc = "Toggle Colorizer" })
end)
