if true then
    return
end
vim.pack.add({ { src = "https://github.com/olimorris/codecompanion.nvim", version = "v17.33.0" }, "https://github.com/nvim-lua/plenary.nvim" })
-- dependencies
--   "nvim-treesitter/nvim-treesitter",

require("codecompanion").setup({
    opts = {
        log_level = "DEBUG", -- or "TRACE"
    },
})
