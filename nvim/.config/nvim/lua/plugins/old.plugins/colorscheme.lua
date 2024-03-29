return {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    config = function(_, _)
        -- Defaults are commented out
        require('gruvbox').setup({
            -- undercurl = true,
            -- underline = true,
            -- bold = true,
            italic = {
                strings = false,
                comments = false,
                -- operators = false,
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
    end,
}

-- return {
--
--   "neanias/everforest-nvim",
--   version = false,
--   lazy = false,
--   priority = 1000, -- make sure to load this before all the other start plugins
--   -- Optional; default configuration will be used if setup isn't called.
--   config = function()
--     require("everforest").setup({
--       -- Your config here
--     })
--     vim.cmd.colorscheme('everforest')
--   end,
--
--
--
-- }
