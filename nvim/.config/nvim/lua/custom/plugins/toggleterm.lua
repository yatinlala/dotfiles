local M = {
    'akinsho/toggleterm.nvim',
    -- cmd = "ToggleTerm",
    keys = [[<c-\>]],
    enabled = true,
}

function M.config()
    require('toggleterm').setup({
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        direction = 'float',
        float_opts = {
            border = 'curved',
            winblend = 0,
            highlights = {
                border = 'Normal',
                background = 'Normal',
            },
        },
    })

    function _G.set_terminal_keymaps()
        local opts = { noremap = true }
        vim.api.nvim_buf_set_keymap(0, 't', 'JK', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
end

return M
