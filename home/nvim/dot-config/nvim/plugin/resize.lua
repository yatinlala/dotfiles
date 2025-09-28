local STEP = 1

local function has_neighbor(dir)
    return vim.fn.winnr(dir) ~= vim.fn.winnr()
end

local info = {
    h = { opposite = "l", vert = true, default = "-" },
    j = { opposite = "k", default = "+" },
    l = { opposite = "h", vert = true, default = "+" },
    k = { opposite = "j", default = "-" },
}

local function resize(dir)
    local cmd = ""
    if info[dir].vert then
        cmd = "vertical "
    end
    cmd = cmd .. "resize "
    if has_neighbor(info[dir].opposite) and has_neighbor(dir) then
        cmd = cmd .. info[dir].default
    elseif has_neighbor(dir) then
        cmd = cmd .. "+"
    else
        cmd = cmd .. "-"
    end
    vim.cmd(cmd .. STEP)
end

vim.keymap.set({ "n", "t" }, "<M-h>", function()
    resize("h")
end, { desc = "Smart resize left" })
vim.keymap.set({ "n", "t" }, "<M-l>", function()
    resize("l")
end, { desc = "Smart resize right" })
vim.keymap.set({ "n", "t" }, "<M-k>", function()
    resize("k")
end, { desc = "Smart resize up" })
vim.keymap.set({ "n", "t" }, "<M-j>", function()
    resize("j")
end, { desc = "Smart resize down" })
