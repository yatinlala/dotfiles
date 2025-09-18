vim.pack.add({ { src = "https://github.com/sakhnik/nvim-gdb", version = "devel" } })

vim.g.nvimgdb_disable_start_keymaps = true

vim.keymap.set("n", "<leader>ds", ":GdbStart gdb -q ", { desc = "Start gdb session" })
vim.keymap.set("n", "<leader>dl", ":GdbCreateWatch info locals<CR>", { desc = "Watch locals" })
vim.keymap.set("n", "<leader>db", "<cmd>GdbBreakpointToggle<CR>", { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dn", "<cmd>GdbNext<CR>", { desc = "Gdb Next" })
vim.keymap.set("n", "<leader>dc", "<cmd>GdbContinue<CR>", { desc = "Gdb Continue" })

vim.keymap.set("n", "<leader>ds", ":GdbStart gdb -q ", {
    desc = "Start gdb session (with locals watch)",
})

-- vim.keymap.set("n", "<leader>ds", function()
--     local prog = vim.fn.input("Program to debug: ")
--     if prog == "" then
--         return
--     end
--     vim.cmd("GdbStart gdb -q " .. prog)
--     vim.schedule(function()
--         vim.cmd("GdbCreateWatch info locals")
--         vim.cmd("wincmd p")
--     end)
-- end, { desc = "Start gdb session with locals watch" })
