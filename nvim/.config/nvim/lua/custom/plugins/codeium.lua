return {
    'Exafunction/codeium.nvim',
    event = 'VeryLazy',
    -- main = 'codeium',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    keys = {
        {
            '<M-]>',
            function()
                require('codeium.virtual_text').cycle_or_complete()
            end,
            mode = 'i',
            desc = 'Codeium Complete/Cycle',
        },
    },
    opts = {
        enable_cmp_source = false,
        virtual_text = {
            enabled = true,
            manual = true,
            map_keys = true,
            -- Key bindings for managing completions in virtual text mode.
            key_bindings = {
                -- Accept the current completion.
                accept = '<Tab>',
                -- Accept the next word.
                accept_word = false,
                -- Accept the next line.
                accept_line = false,
                -- Clear the virtual text.
                clear = '<M-c>',
                -- Cycle to the next completion.
                next = false,
                -- Cycle to the previous completion.
                prev = '<M-[>',
            },
        },
    },
}
