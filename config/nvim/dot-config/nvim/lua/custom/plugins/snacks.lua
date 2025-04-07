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
                -- Snacks.picker.files()
                Snacks.picker.smart()
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
        {
            '<leader>bd',
            function()
                Snacks.bufdelete()
            end,
            desc = '[B]uffer [D]elete',
        },
        {
            '<leader>ba',
            function()
                Snacks.bufdelete.other()
            end,
            desc = 'Delete [B]uffer [A]ll',
        },
    },
    opts = {
        bigfile = { enabled = true },
        -- explorer = { enabled = true },
        -- notifier = { enabled = true }, -- doesn't seem to work
        -- scope = {},
        image = { enabled = true },
        indent = {
            enabled = true,
            char = "┆", -- TODO doesn't work?
            animate = { enabled = false }
        },
        quickfile = { enabled = true },
        picker = {
            layout = {
                preset = "ivy_split"
            }
        },
    },
}
