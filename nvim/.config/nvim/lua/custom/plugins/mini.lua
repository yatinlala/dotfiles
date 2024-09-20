return {
    'echasnovski/mini.nvim',
    version = false,
    event = 'VeryLazy',
    config = function()
        require('mini.splitjoin').setup()

        local ai = require('mini.ai')
        ai.setup({
            custom_textobjects = {
                B = require('mini.extra').gen_ai_spec.buffer(),
                F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
            },
        })

        require('mini.icons').setup()

        require('mini.tabline').setup()

        -- -- TODO figure out how this works
        -- require('mini.sessions').setup({ autoread = true })

        require('mini.operators').setup({
            -- Each entry configures one operator.
            -- `prefix` defines keys mapped during `setup()`: in Normal mode
            -- to operate on textobject and line, in Visual - on selection.

            -- Evaluate text and replace with output
            evaluate = {
                -- prefix = 'g=',
                prefix = '',
            },
            exchange = {
                prefix = 'gx',
                -- Whether to reindent new text to match previous indent
                reindent_linewise = true,
            },
            -- Multiply (duplicate) text
            multiply = {
                prefix = 'gm',
                -- Function which can modify text before multiplying
                func = nil,
            },
            -- Replace text with register
            replace = {
                prefix = 'gr',
                -- Whether to reindent new text to match previous indent
                reindent_linewise = true,
            },

            -- Sort text
            sort = {
                prefix = '',
                -- prefix = 'gs',

                -- Function which does the sort
                func = nil,
            },
        }) -- gr, g=, gx, gm, gs

        -- require('mini.completion').setup()

        -- local hipatterns = require('mini.hipatterns')
        -- hipatterns.setup({
        --     highlighters = {
        --         fixme = { pattern = 'FIXME', group = 'MiniHipatternsHack' },
        --         hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
        --         todo = { pattern = 'TODO', group = 'MiniHipatternsHack' },
        --         note = { pattern = 'NOTE', group = 'MiniHipatternsHack' },
        --         hex_color = hipatterns.gen_highlighter.hex_color(),
        --     },
        -- })

        -- require('mini.surround').setup()
    end,
}
