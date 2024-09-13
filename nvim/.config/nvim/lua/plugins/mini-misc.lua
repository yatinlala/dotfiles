return {
    'echasnovski/mini.misc',
    version = '*',
    event = 'VeryLazy',
    config = function()
        require('mini.misc').setup_auto_root()
    end,
}
