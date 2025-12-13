local lazy_load = require("extern-plugins").lazy_load

-- vim.api.nvim_create_autocmd("BufReadPre", {
--     callback = function()
--
--         vim.keymap.set("n", "<leader>C", "<cmd>ColorizerToggle<CR>", { desc = "Toggle Colorizer" })
--     end,
-- })

-- require("plugins.util").packadd({ })

vim.keymap.set("n", "<leader>C", "<cmd>ColorizerToggle<CR>", { desc = "Toggle Colorizer" })

lazy_load({
    {
        src = "https://github.com/catgoose/nvim-colorizer.lua",
        data = {
            cmd = "ColorizerToggle",
            config = function()
                require("colorizer").setup()
            end,
        },
    },
})
