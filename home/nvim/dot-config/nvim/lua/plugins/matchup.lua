-- Supercharge %, replace matchparen, add g%, [%, ]%, z%
vim.pack.add({ "https://github.com/andymass/vim-matchup" })

-- keys = { '%' }, -- TODO this doesn't work for some reason
-- vim.cmd([[ hi MatchWord guibg=#504945 ]])
vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
vim.g.matchup_matchparen_deferred = 1
vim.b.matchup_matchparen_enabled = 0
