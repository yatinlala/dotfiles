-- return {
--     'folke/persistence.nvim',
--     event = 'BufReadPre', -- this will only start session saving when an actual file was opened
--     keys = {
--         -- load the session for the current directory
--         { '<leader>qs', function() require('persistence').load() end), { desc = "Load session for current dir" } }
--     },
-- }
return {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {},
    keys = {
        {
            '<leader>qs',
            function()
                require('persistence').load()
            end,
            desc = 'Load session for current dir',
        },
        {
            '<leader>qS',
            function()
                require('persistence').select()
            end,
            desc = 'Select a session to load',
        },
        {
            '<leader>ql',
            function()
                require('persistence').load({ last = true })
            end,
            desc = 'Load the last session',
        },
        {
            '<leader>qd',
            function()
                require('persistence').stop()
            end,
            desc = "Stop Persistence => session won't be saved on exit",
        },
    },
}
