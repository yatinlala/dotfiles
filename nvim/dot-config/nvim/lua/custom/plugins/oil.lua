return {
    'stevearc/oil.nvim',
    enabled = false,
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    keys = { { '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' } } },
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
