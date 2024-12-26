return {
    'is0n/fm-nvim',
    keys = {
        {
            '<leader>e',
            function()
                vim.cmd('Lf ' .. '"' .. vim.fn.expand('%') .. '"')
            end,
            { desc = 'Find [F]iles' },
        },
    },
    opts = {
        ui = {
            float = {
                -- border = 'single',
            },
        },
    },
    cmd = { 'Lazygit', 'Lf' },
}
