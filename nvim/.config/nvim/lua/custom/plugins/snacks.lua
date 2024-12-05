return {
    'folke/snacks.nvim',
    lazy = false,
    keys = {
        {
            '<C-\\>',
            function()
                Snacks.terminal.toggle()
            end,
            mode = { 'n', 't' },
            desc = '[T]oggle Terminal',
        },
        {
            '<leader>.',
            function()
                Snacks.scratch()
            end,
            desc = 'Toggle Scratch Buffer',
        },
        {
            '<leader>S',
            function()
                Snacks.scratch.select()
            end,
            desc = 'Select Scratch Buffer',
        },
    },
    opts = {
        quickfile = {},
    },
}
