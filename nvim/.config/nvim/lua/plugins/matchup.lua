-- Supercharge %, replace matchparen, add g%, [%, ]%, z%
return {
    'andymass/vim-matchup',
    lazy = false,
    init = function()
        vim.cmd([[ hi MatchWord cterm=underline gui=underline ]])
        vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
        vim.g.matchup_matchparen_deferred = 1
        vim.b.matchup_matchparen_enabled = 0

        require'nvim-treesitter.configs'.setup {
          matchup = {
            enable = true,              -- mandatory, false will disable the whole extension
            disable = { "c", "ruby" },  -- optional, list of language that will be disabled
            -- [options]
          }
        }
    end,
}
