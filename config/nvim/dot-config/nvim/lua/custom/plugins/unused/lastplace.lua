return {
    'ethanholz/nvim-lastplace',
    event = 'BufWinEnter',
    enabled = false,
    config = function()
        require('nvim-lastplace').setup({
            lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
            lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
            lastplace_open_folds = false,
        })
    end,
}
