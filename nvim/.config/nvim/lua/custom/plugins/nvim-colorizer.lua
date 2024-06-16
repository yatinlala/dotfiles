return {
    'NVChad/nvim-colorizer.lua',
    cmd = 'ColorizerToggle',
    keys = { '<leader>C' },
    config = function()
        require('colorizer').setup()

        vim.keymap.set('n', '<leader>C', '<cmd>ColorizerToggle<CR>', { desc = 'toggle colorizer' })
    end,
}
