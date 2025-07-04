return { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy',
    keys = {
        {
            '<leader>?',
            function()
                require('which-key').show({ global = false })
            end,
            desc = 'Buffer Local Keymaps (which-key)',
        },
    },
    opts = {
        spec = {
            -- { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
            { '<leader>o', group = '[O]rg Mode' },
            { '<leader>l', group = '[L]sp',      mode = { 'n', 'x' } },
            { '<leader>g', group = '[G]it' },
            { '<leader>a', group = '[A]I',       mode = { 'n', 'x' } },
            { '<leader>q', group = 'Persistence' },
            -- -- { '<leader>d', group = '[D]ocument' },
            -- { '<leader>g', group = '[G]it' },
            -- { '<leader>l', group = '[L]sp' },
            -- -- { '<leader>f', group = '[F]ind' },
            -- -- { '<leader>t', group = '[T]reesitter' },
            -- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        },
        icons = {
            keys = {
                Up = '<Up> ',
                Down = '<Down> ',
                Left = '<Left> ',
                Right = '<Right> ',
                C = '<C-…> ',
                M = '<M-…> ',
                D = '<D-…> ',
                S = '<S-…> ',
                CR = '<CR> ',
                Esc = '<Esc> ',
                ScrollWheelDown = '<ScrollWheelDown> ',
                ScrollWheelUp = '<ScrollWheelUp> ',
                NL = '<NL> ',
                BS = '<BS> ',
                Space = '<Space> ',
                Tab = '<Tab> ',
                F1 = '<F1>',
                F2 = '<F2>',
                F3 = '<F3>',
                F4 = '<F4>',
                F5 = '<F5>',
                F6 = '<F6>',
                F7 = '<F7>',
                F8 = '<F8>',
                F9 = '<F9>',
                F10 = '<F10>',
                F11 = '<F11>',
                F12 = '<F12>',
            },
        },
    },
}
