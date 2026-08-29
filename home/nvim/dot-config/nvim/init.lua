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

require("extern-plugins").init()
require("config.keymaps")
require("config.options")

vim.cmd.packadd("nvim.undotree")
