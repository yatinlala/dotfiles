return {
    {
        'ellisonleao/gruvbox.nvim',
        priority = 1000,
        -- enabled = false,
        lazy = false,
        enabled = true,
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
                -- invert_tabline = true,
                contrast = '', -- can be "hard", "soft" or empty string
            })
            vim.cmd.colorscheme('gruvbox')

            -- You can configure highlights by doing something like:
            -- vim.cmd.hi('Comment gui=none')
        end,
    },
    -- {
    --     'eddyekofo94/gruvbox-flat.nvim',
    --     -- lazy = false,
    --     priority = 1000,
    --     enabled = false,
    --     config = function()
    --         vim.cmd([[colorscheme gruvbox-flat]])
    --     end,
    -- },
    -- {
    --     'luisiacc/gruvbox-baby',
    --     -- lazy = false,
    --     priority = 1000,
    --     enabled = false,
    --     config = function()
    --         vim.cmd([[colorscheme gruvbox-baby]])
    --     end,
    -- },
    -- {
    --     'sainnhe/gruvbox-material',
    --     -- lazy = false,
    --     priority = 1000,
    --     enabled = false,
    --     config = function()
    --         vim.g.gruvbox_material_better_performance = 1
    --         -- vim.g.gruvbox_material_background = 'medium'
    --         vim.g.gruvbox_material_disable_italic_comment = 1
    --         vim.g.gruvbox_material_foreground = "material"
    --         vim.cmd([[colorscheme gruvbox-material]])
    --     end,
    -- },
    -- {
    --     'f4z3r/gruvbox-material.nvim',
    --     name = 'gruvbox-material',
    --     lazy = false,
    --     priority = 1000,
    --     opts = {
    --         comments = {
    --             italics = false,
    --         },
    --     },
    -- },
}
