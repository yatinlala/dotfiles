return {
    -- gS toggles b/t function args on one line and function args with one arg per line
    'echasnovski/mini.splitjoin',
    version = false,
    config = function()
        require('mini.splitjoin').setup()
    end,
    keys = 'gS',
}
