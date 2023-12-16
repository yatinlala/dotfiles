return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy', -- kills splash
    enabled = true,
    config = function()
        if vim.g.started_by_firenvim then
            return
        end

        require('lualine').setup({
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {},
                always_divide_middle = true,
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diagnostics' },
                lualine_c = { { 'filename', path = 3 } },
                -- lualine_c = {
                -- 	-- {'filename', path = 2 }, { require('nvim-navic').get_location, cond = require('nvim-navic').is_available },
                -- },
                lualine_x = { 'diff', 'filetype' },
                lualine_y = {},

                lualine_z = { 'location' },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {},
            },
            -- tabline = {
            --     lualine_a = {
            --         { 'buffers',
            --             symbols = {
            --                 modified = ' ●', -- Text to show when the buffer is modified
            --                 alternate_file = '', -- Text to show to identify the alternate file
            --                 directory = '', -- Text to show when the buffer is a directory
            --             }, }
            --     },
            --     lualine_b = {},
            --     lualine_c = {},
            --     lualine_x = {},
            --     lualine_y = {},
            --     lualine_z = { 'tabs' }
            -- },

            extensions = {},
        })
    end,
}
