vim.api.nvim_create_user_command("ToggleBackground", function()
    if vim.o.background == "dark" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end
end, {})
--
vim.api.nvim_create_user_command("EC", "silent cd ~/.config/nvim | e $MYVIMRC", {})

-- vim.api.nvim_create_user_command('Redir', ":0put=execute('highlight')", {})

-- vim.api.nvim_create_user_command("Today", function()
--     require("util").open_diary_date()
-- end, {})

-- vim.api.nvim_create_user_command('OpenGithubRepo', function(_)
--     local ghpath = vim.api.nvim_eval("shellescape(expand('<cfile>'))")
--     local formatpath = ghpath:sub(2, #ghpath - 1)
--     local repourl = 'https://www.github.com/' .. formatpath
--     vim.fn.system({ 'xdg-open', repourl })
-- end, {
--     desc = 'Open Github Repo',
--     force = true,
-- })
