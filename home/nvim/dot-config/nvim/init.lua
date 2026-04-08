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

if not vim.g.neovide then
    require("vim._core.ui2").enable({
        enable = true, -- Whether to enable or disable the UI.
        msg = {
            targets = "cmd",
            cmd = {
                height = 0.4,
            },
            dialog = { -- Options related to dialog window.
                height = 0.5, -- Maximum height.
            },
            msg = { -- Options related to msg window.
                height = 0.5, -- Maximum height.
                timeout = 4000, -- Time a message is visible in the message window.
            },
            pager = { -- Options related to message window.
                height = 1, -- Maximum height.
            },
        },
    })
end

require("extern-plugins").init()
require("config.keymaps")
require("config.options")

vim.cmd.packadd("nvim.undotree")
