vim.api.nvim_create_user_command("ToggleBackground", function()
    if vim.o.background == "dark" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end
end, {})

vim.api.nvim_create_user_command("Lf", function()
    require("lf").show()
end, {
    desc = "Show Lf window",
})

vim.api.nvim_create_user_command("EC", "silent cd ~/.config/nvim | e $MYVIMRC", {})

vim.api.nvim_create_user_command("Pack", function(opts)
    local args = opts.fargs

    if args[1] == "update" then
        vim.pack.update()
    elseif args[1] == "lock" then
        vim.pack.update(nil, { target = "lockfile" })
    else
        print("unknown subcommand")
    end
end, {
    nargs = "+",
    complete = function(arglead, cmdline, cursorpos)
        local subcommands = { "update", "lock" }
        return vim.tbl_filter(function(cmd)
            return cmd:find("^" .. arglead)
        end, subcommands)
    end,
})

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
