vim.pack.add({ { src = "https://github.com/sakhnik/nvim-gdb", version = "devel" } })

vim.keymap.set("n", "<leader>dB", "<cmd>GdbBreakpointToggle<CR>", { desc = "Toggle Breakpoint" })
