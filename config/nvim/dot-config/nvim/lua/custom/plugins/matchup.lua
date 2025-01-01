-- Supercharge %, replace matchparen, add g%, [%, ]%, z%
return {
    'andymass/vim-matchup',
    event = { 'BufReadPost', 'BufNewFile' },
    -- dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- lazy = false,
    -- keys = { '%' }, -- TODO this doesn't work for some reason
    init = function()
        -- vim.cmd([[ hi MatchWord guibg=#504945 ]])
        vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
        vim.g.matchup_matchparen_deferred = 1
        vim.b.matchup_matchparen_enabled = 0
    end,
}
