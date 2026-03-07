vim.pack.add({
    {
        src = "https://github.com/obsidian-nvim/obsidian.nvim",
        version = vim.version.range("*"), -- use latest release, remove to use latest commit
    },
})

require("obsidian").setup({

    workspaces = {
        {
            name = "personal",
            path = "~/documents/notes",
        },
    },
    legacy_commands = false,
})

vim.keymap.set("n", "<leader>oq", "<cmd>Obsidian quick_switch<CR>", {})
vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<CR>", {})
