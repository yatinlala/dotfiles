return {
    'NVChad/nvim-colorizer.lua',
    cmd = 'ColorizerToggle',
    keys = {
        { '<leader>C', '<cmd>ColorizerToggle<CR>', desc = 'toggle colorizer' },
    },
    config = function()
        require('colorizer').setup()
    end,
}
