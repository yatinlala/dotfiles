return {
    -- {
    --     'ellisonleao/gruvbox.nvim',
    --     priority = 1000,
    --     lazy = false,
    --     enabled = true,
    --     init = function()
    --         require('gruvbox').setup({
    --             -- undercurl = true,
    --             -- underline = true,
    --             -- bold = true,
    --             italic = {
    --                 strings = false,
    --                 comments = false,
    --                 operators = false,
    --                 emphasis = true,
    --                 folds = false,
    --             },
    --             -- invert_tabline = true,
    --             contrast = '', -- can be "hard", "soft" or empty string
    --         })
    --         vim.cmd.colorscheme('gruvbox')
    --
    --         -- You can configure highlights by doing something like:
    --         -- vim.cmd.hi('Comment gui=none')
    --     end,
    -- },
    -- {
    --     'eddyekofo94/gruvbox-flat.nvim',
    --     lazy = false,
    --     enabled = true,
    --     priority = 1000,
    --     config = function()
    --         vim.g.gruvbox_flat_style = 'dark'
    --         vim.cmd([[colorscheme gruvbox-flat]])
    --     end,
    -- },
    -- {
    --     'rebelot/kanagawa.nvim',
    --     lazy = false,
    --     enabled = false,
    --     priority = 1000,
    --     init = function()
    --         vim.cmd('colorscheme kanagawa-wave')
    --     end,
    -- },
    --
    -- {
    --     'luisiacc/gruvbox-baby',
    --     lazy = false,
    --     priority = 1000,
    --     enabled = true,
    --     config = function()
    --         vim.cmd([[colorscheme gruvbox-baby]])
    --     end,
    -- },
    -- {
    --     'sainnhe/gruvbox-material',
    --     lazy = false,
    --     priority = 1000,
    --     enabled = false,
    --     config = function()
    --         vim.g.gruvbox_material_better_performance = 1
    --         -- vim.g.gruvbox_material_transparent_background = 1
    --         vim.g.gruvbox_material_diagnostic_line_highlight = 1
    --         vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
    --         vim.g.gruvbox_material_background = 'medium'
    --         vim.g.gruvbox_material_disable_italic_comment = 1
    --         vim.g.gruvbox_material_enable_bold = 1
    --         vim.g.gruvbox_material_foreground = 'material'
    --
    --         -- changing bg and border colors
    --         vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
    --         vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'Normal' })
    --         vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
    --
    --         vim.cmd([[colorscheme gruvbox-material]])
    --     end,
    -- },
    {
        'sainnhe/gruvbox-material',
        lazy = false,
        priority = 1000,
        enabled = true,
        config = function()
            vim.g.gruvbox_material_transparent_background = 0
            vim.g.gruvbox_material_foreground = 'material'
            vim.g.gruvbox_material_background = 'hard'    -- soft, medium, hard
            vim.g.gruvbox_material_ui_contrast = 'high'   -- The contrast of line numbers, indent lines, etc.
            vim.g.gruvbox_material_float_style = 'bright' -- Background of floating windows
            vim.g.gruvbox_material_statusline_style = 'mix'
            vim.g.gruvbox_material_cursor = 'auto'

            -- vim.cmd([[
            --     "let g:gruvbox_material_colors_override = { 'bg_statusline1': ['#81a2be', '234'], 'bg0': ['#ffffff', '0'], }
            --
            --     let g:gruvbox_material_colors_override = {'bg_statusline1': ['#81a2be', '234'], 'bg2': ['#282828', '235']}
            --     ]])
            vim.g.gruvbox_material_better_performance = 1

            vim.cmd.colorscheme('gruvbox-material')

            -- vim.cmd("hi NormalFloat guibg=#282828")
            vim.cmd("hi! link FloatBorder Normal")
            -- vim.cmd("hi! link NormalFloat Normal")

            -- vim.cmd('hi StatusLine guibg=#83a598 guifg=#fbf1c7')
        end,
    },

    -- {
    --     'f4z3r/gruvbox-material.nvim',
    --     name = 'gruvbox-material',
    --     lazy = false,
    --     enabled = false,
    --     priority = 1000,
    --     opts = {
    --         comments = {
    --             italics = false,
    --         },
    --     },
    -- },
}
