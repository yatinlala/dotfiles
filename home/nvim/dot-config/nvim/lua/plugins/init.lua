local function req(name)
    local ok, _ = pcall(require, name)
    if not ok then
        print("failed to load " .. name)
    end
end

req("plugins.gruvbox")
req("plugins.treesitter")
req("plugins.mason")
req("plugins.conform")
req("plugins.lazydev")
req("plugins.blink")
req("plugins.gitsigns")
req("plugins.flatten")
req("plugins.matchup")
req("plugins.snacks")
req("plugins.mini")
req("plugins.ufo")
req("plugins.ts-autotag")
req("plugins.which-key")

vim.pack.add({ "https://github.com/tpope/vim-sleuth" })
vim.pack.add({ "https://github.com/tpope/vim-eunuch" })
