return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    enabled = true,
    config = function()
        if vim.g.started_by_firenvim then
            return
        end

        require('lualine').setup({
            options = {
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {
                    -- {
                    --     'buffers',
                    --     path = 3,
                    --     max_length = vim.o.columns * 1 / 3,
                    --     -- buffers_color = {
                    --     --     -- Same values as the general color option can be used here.
                    --     --     active = 'lualine_c_visual', -- Color for active buffer.
                    --     --     inactive = 'lualine_c_inactive', -- Color for inactive buffer.
                    --     -- },
                    --     symbols = {
                    --         alternate_file = '', -- Text to show to identify the alternate file
                    --     },
                    -- },
                },
                lualine_c = {
                    '%=',
                    {
                        'filename',
                        path = 3,
                        shorting_target = 40,
                    },
                },
                -- lualine_c = {
                -- 	-- {'filename', path = 2 }, { require('nvim-navic').get_location, cond = require('nvim-navic').is_available },
                -- },
                lualine_x = {
                    'diagnostics',
                    'branch',
                    'diff',
                    'filetype'
                },
                lualine_y = {},

                lualine_z = { 'location' },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
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
        })
    end,
}
