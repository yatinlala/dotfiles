-- Supercharge %, replace matchparen, add g%, [%, ]%, z%
return {
  'andymass/vim-matchup',
  event = 'BufReadPost',
  init = function()
    vim.cmd([[ hi MatchWord cterm=underline gui=underline ]])
    vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
    vim.g.matchup_matchparen_deferred = 1
    vim.b.matchup_matchparen_enabled = 0
  end,
}
