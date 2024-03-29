return {
    {
        'akinsho/bufferline.nvim',
        event = 'BufReadPre',
        -- lazy = false,
        enabled = true,
        config = function()
            require('bufferline').setup({
                options = {
                    style_preset = require('bufferline').style_preset.no_italic,
                    buffer_selected = {
                        italic = false,
                    },
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                },
            })
        end,
    },
    {
        'tiagovla/scope.nvim',
        lazy = false,
        enabled = true,
        opts = {},
    },
}
