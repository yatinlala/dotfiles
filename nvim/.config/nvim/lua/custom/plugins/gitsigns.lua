return {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    keys = {
        {
            '<leader>gj',
            function()
                require('gitsigns').next_hunk()
            end,
            desc = 'Next Hunk',
        },
        {
            '<leader>gk',
            function()
                require('gitsigns').prev_hunk()
            end,
            desc = 'Previous Hunk',
        },
        {
            '<leader>gl',
            function()
                require('gitsigns').blame_line()
            end,
            desc = 'Blame Line',
        },
        {
            '<leader>gp',
            function()
                require('gitsigns').blame_line()
            end,
            desc = 'Blame Line',
        },
        {
            '<leader>gr',
            function()
                require('gitsigns').reset_hunk()
            end,
            desc = 'Reset Hunk',
        },
        --         p = { function() require('gitsigns').preview_hunk() end, 'Preview Hunk', },
        --         R = { function() require('gitsigns').reset_buffer() end, 'Reset Buffer', },
        --         s = { function() require('gitsigns').stage_hunk() end, 'Stage Hunk', },
        --         u = { function() require('gitsigns').undo_stage_hunk() end, 'Undo Stage Hunk', },
    },
    opts = {},
}
