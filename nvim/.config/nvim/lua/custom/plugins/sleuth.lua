-- Set shiftwidth and expandtab based on file
return {
    'tpope/vim-sleuth',
    event = 'BufReadPost',
    init = function()
        vim.g.sleuth_sh_heuristics = 0
        vim.g.sleuth_bash_heuristics = 0
    end,
    enabled = true,
}
