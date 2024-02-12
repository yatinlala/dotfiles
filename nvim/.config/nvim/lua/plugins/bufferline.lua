return {
    {
        'akinsho/bufferline.nvim',
        event = 'BufReadPre',
        enabled = false,
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
        event = 'BufReadPre',
        enabled = false,
        opts = {},
    },
}
