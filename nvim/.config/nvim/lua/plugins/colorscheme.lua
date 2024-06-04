return {
    {
        'ellisonleao/gruvbox.nvim',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        init = function()
            require('gruvbox').setup({
                -- undercurl = true,
                -- underline = true,
                -- bold = true,
                italic = {
                    strings = false,
                    comments = false,
                    operators = false,
                    emphasis = true,
                    folds = false,
                },
                -- strikethrough = true,
                -- invert_selection = false,
                -- invert_signs = false,
                invert_tabline = true,
                -- invert_intend_guides = false,
                -- inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = '', -- can be "hard", "soft" or empty string
                -- palette_overrides = {},
                -- overrides = {},
                -- dim_inactive = false,
                -- transparent_mode = false,
            })
            vim.cmd.colorscheme('gruvbox')

            -- You can configure highlights by doing something like:
            -- vim.cmd.hi('Comment gui=none')
        end,
    },
}
