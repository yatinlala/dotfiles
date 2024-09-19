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

        require('mini.tabline').setup()

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
