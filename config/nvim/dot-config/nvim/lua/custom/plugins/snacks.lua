return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    keys = {
        -- {
        --     '<C-\\>',
        --     function()
        --         Snacks.terminal.toggle()
        --     end,
        --     mode = { 'n', 't' },
        --     desc = '[T]oggle Terminal',
        -- },
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
        {
            '<leader>f',
            function()
                Snacks.picker.files()
            end,
            desc = 'Pick [F]iles',
        },
        -- {
        --     '<leader>f',
        --     function()
        --         Snacks.picker.files()
        --     end,
        --     desc = 'Select Scratch Buffer',
        -- },
        {
            '<leader>h',
            function()
                Snacks.picker.help()
            end,
            desc = 'Pick [H]elp',
        },
        {
            '<leader>G',
            function()
                Snacks.picker.grep()
            end,
            desc = 'Live [G]rep',
        },
    },
    opts = {
        -- notifier = { enabled = true }, -- doesn't seem to work
        -- scope = {},
        -- image = {},
        quickfile = {},
        picker = {
            layout = {
                preset = "ivy_split"
            }
        },
    },
}
