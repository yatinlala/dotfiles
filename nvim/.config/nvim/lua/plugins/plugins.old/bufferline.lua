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
        event = 'BufReadPre',
        enabled = true,
        config = function()
            require("scope").setup()
            require("telescope").load_extension("scope")
        end
    },
}

-- [[ Use tabline instead ]]
-- return {
--     'mkitt/tabline.vim',
--     dependencies = 'ellisonleao/gruvbox.nvim',
--     enabled = false,
--     lazy = false,
--     config = function()
--         vim.cmd([[
--             hi TabLine      guifg=#bdae93  guibg=#282828     gui=NONE
--             hi TabLineFill  guifg=#bdae93  guibg=#282828     gui=NONE
--             hi TabLineSel   guifg=#ebdbb2  guibg=#282828     gui=NONE
--         ]])
--     end,
-- }
