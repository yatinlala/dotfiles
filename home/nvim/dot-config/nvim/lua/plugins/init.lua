local M = {}

function M.init()
    local plugin_files = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/plugins", "*.lua", false, true)

    for _, file in ipairs(plugin_files) do
        local mod = file:match("lua/(.*)%.lua$")
        if mod ~= "plugins/init" then
            require(mod)
        end
    end

    vim.pack.add({ "https://github.com/tpope/vim-sleuth" })
    vim.pack.add({ "https://github.com/tpope/vim-eunuch" })
end

-- function vim.pack.add(specs, opts)
--     opts = opts or {}
--     opts.confirm = false
--     return vim.pack.add(specs, opts)
-- end

local group = vim.api.nvim_create_augroup("PluginStuff", { clear = true })

-- https://github.com/neovim/neovim/pull/35360#issuecomment-3212327279
vim.api.nvim_create_autocmd("PackChanged", {
    group = group,
    pattern = "*",
    callback = function(e)
        local p = e.data
        local run_task = (p.spec.data or {}).run
        if p.kind ~= "delete" and type(run_task) == "function" then
            pcall(run_task, p)
        end
    end,
})

-- https://www.reddit.com/r/neovim/comments/1mx71rc/how_i_vastly_improved_my_lazy_loading_experience/
-- TODO make this support nested tables for keys and cmds. good enough for now

---@param plugins (string|vim.pack.Spec)[]
function M.lazy_load(plugins)
    vim.pack.add(plugins, {
        load = function(plugin)
            local data = plugin.spec.data or {}

            -- Event trigger
            if data.event then
                vim.api.nvim_create_autocmd(data.event, {
                    group = group,
                    once = true,
                    pattern = data.pattern or "*",
                    callback = function()
                        vim.cmd.packadd(plugin.spec.name)
                        if data.config then
                            data.config(plugin)
                        end
                    end,
                })
            end

            -- Command trigger
            if data.cmd then
                vim.api.nvim_create_user_command(data.cmd, function(cmd_args)
                    pcall(vim.api.nvim_del_user_command, data.cmd)
                    vim.cmd.packadd(plugin.spec.name)
                    if data.config then
                        data.config(plugin)
                    end
                    vim.api.nvim_cmd({
                        cmd = data.cmd,
                        args = cmd_args.fargs,
                        bang = cmd_args.bang,
                        nargs = cmd_args.nargs,
                        range = cmd_args.range ~= 0 and { cmd_args.line1, cmd_args.line2 } or nil,
                        count = cmd_args.count ~= -1 and cmd_args.count or nil,
                    }, {})
                end, {
                    nargs = data.nargs,
                    range = data.range,
                    bang = data.bang,
                    complete = data.complete,
                    count = data.count,
                })
            end

            -- Keymap trigger
            if data.keys then
                local mode, lhs = data.keys[1], data.keys[2]
                vim.keymap.set(mode, lhs, function()
                    vim.keymap.del(mode, lhs)
                    vim.cmd.packadd(plugin.spec.name)
                    if data.config then
                        data.config(plugin)
                    end
                    vim.api.nvim_feedkeys(vim.keycode(lhs), "m", false)
                end, { desc = data.desc })
            end
        end,
    })
end

return M
