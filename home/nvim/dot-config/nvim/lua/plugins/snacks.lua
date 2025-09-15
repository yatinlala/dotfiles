if true then
    return
end
vim.pack.add({ "https://github.com/folke/snacks.nvim" })

vim.keymap.set("n", "<leader>f", function()
    -- Snacks.picker.files()
    Snacks.picker.smart()
end, { desc = "Pick [F]iles" })
vim.keymap.set("n", "<leader>h", function()
    Snacks.picker.help()
end, { desc = "Pick [H]elp" })
vim.keymap.set("n", "<leader>G", function()
    Snacks.picker.grep()
end, { desc = "Live [G]rep" })
vim.keymap.set("n", "<leader>D", function()
    Snacks.bufdelete()
end, { desc = "[B]uffer [D]elete" })
-- vim.keymap.set("n", "<leader>ba", function()
--     Snacks.bufdelete.other()
-- end, { desc = "Delete [B]uffer [A]ll" })

require("snacks").setup({
    bigfile = { enabled = true },
    image = {
        enabled = true,
        doc = {
            inline = false,
            max_width = 40,
            max_height = 20,
        },
    },
    -- indent = {
    --     enabled = true,
    --     char = "┆", -- TODO doesn't work?
    --     animate = { enabled = false },
    -- },
    quickfile = { enabled = true },
    picker = {
        layout = {
            preset = "telescope",
        },
    },
})
