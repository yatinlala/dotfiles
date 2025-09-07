if true then
    return
end
return {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    enabled = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        local opts = { noremap = true, silent = true }
        vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", opts)
        vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Code Companion Chat Toggle" })
        vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "Code Companion Chat" })

        -- Expand 'cc' into 'CodeCompanion' in the command line
        vim.cmd([[cab cc CodeCompanion]])

        -- require("codecompanion").setup({
        --     adapters = {
        --         deepseek = function()
        --             return require("codecompanion.adapters").extend("ollama", {
        --                 name = "deepseek",
        --                 schema = {
        --                     model = {
        --                         default = "deepseek-r1:7b",
        --                     },
        --                 },
        --             })
        --         end,
        --     },
        -- })
        require("codecompanion").setup({

            strategies = {
                chat = {
                    adapter = "ollama",
                },
                inline = {
                    adapter = "ollama",
                },
            },
        })
    end,
}
