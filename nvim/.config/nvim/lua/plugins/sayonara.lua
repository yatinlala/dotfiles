return {
    'yashlala/vim-sayonara',
    enabled = false,
    keys = { 'gs', 'gS' },
    config = function()
        vim.g.sayonara_confirm_quit = true
        vim.g.sayonara_dont_quit = true
        vim.keymap.set('n', 'gs', ':Sayonara<CR>', { silent = true })
        vim.keymap.set('n', 'gS', ':Sayonara!<CR>', { silent = true })
    end,
}
