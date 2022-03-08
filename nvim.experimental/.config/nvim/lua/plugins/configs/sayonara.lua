vim.g.sayonara_confirm_quit = true
vim.g.sayonara_dont_quit = true

vim.api.nvim_set_keymap("n", "gs", ":Sayonara<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "gS", ":Sayonara!<CR>", { silent = true })
