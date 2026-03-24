local M = {}

function M.init()
    local plugin_files = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/extern-plugins", "*.lua", false, true)

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

return M
