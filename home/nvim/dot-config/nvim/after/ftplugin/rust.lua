-- rustlings
vim.api.nvim_create_user_command("Rustlings", function()
    vim.keymap.set({ "n" }, "<leader>n", function()
        local cur = vim.fn.expand("%")
        local num = cur:sub(-4, -4)
        local next = cur:sub(1, -5) .. (num + 1) .. ".rs"
        if vim.fn.filereadable(next) == 1 then
            local bufnr = vim.api.nvim_get_current_buf()

            vim.cmd("enew") -- temp
            vim.cmd("bdelete " .. bufnr)

            vim.cmd("edit " .. next)
        else
            print("All problems solved for this topic.")
        end
    end)
end, {})
