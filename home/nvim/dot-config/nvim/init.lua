pcall(function()
    vim.loader.enable()
end)

_G.req = function(name)
    local ok, _ = pcall(require, name)
    if not ok then
        print("failed to load " .. name)
    end
end

-- for some reason, its good practice to set these early.
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("vim._extui").enable({
    enable = true, -- Whether to enable or disable the UI.
    msg = { -- Options related to the message module.
        ---@type 'cmd'|'msg' Where to place regular messages, either in the
        ---cmdline or in a separate ephemeral message window.
        target = "cmd",
        timeout = 4000, -- Time a message is visible in the message window.
    },
})

require("plugins").init()
