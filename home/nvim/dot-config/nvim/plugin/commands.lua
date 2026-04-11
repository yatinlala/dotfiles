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
    elseif args[1] == "list" then
        local pkgs = vim.pack.get()
        local bufnr = vim.api.nvim_create_buf(true, true)

        vim.api.nvim_buf_set_name(bufnr, "nvim-pack://list#" .. bufnr)
        vim.cmd.sbuffer({ bufnr, mods = { tab = vim.fn.tabpagenr() } })

        local lines = {}

        for _, pkg in pairs(pkgs) do
            table.insert(lines, pkg.spec.name)
            -- local lines = vim.iter(pkgs, function(_, pkg)
            --     return pkg.spec.name
            -- end):totable()
        end

        -- table.sort(lines)

        table.insert(lines, 1, #pkgs .. " plugins")
        table.insert(lines, 2, "")

        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    else
        print("unknown subcommand")
    end
end, {
    nargs = "+",
    complete = function(arglead, cmdline, cursorpos)
        local subcommands = { "update", "lock", "list" }
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
