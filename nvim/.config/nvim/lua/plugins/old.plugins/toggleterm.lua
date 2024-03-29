local M = {
    'akinsho/toggleterm.nvim',
    cmd = "ToggleTerm"
}

function M.config()
    require('toggleterm').setup({
        size = 50,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'float',
        close_on_exit = true,
        shell = vim.o.shell,
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

    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
        cmd = 'lazygit',
        -- dir = "git_dir",
        direction = 'float',
        float_opts = {
            border = 'curved',
        },
        -- function to run on opening the terminal
        on_open = function(term)
            vim.cmd('startinsert!')
            vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
        -- function to run on closing the terminal
        on_close = function(term)
            vim.cmd('startinsert!')
        end,
    })

    function _lazygit_toggle()
        lazygit:toggle()
    end

    local lf = Terminal:new({
        cmd = 'lf ' .. vim.fn.expand('%:p'),
        -- dir = vim.fn.expand('%:p'):match("(.*[/\\])"),
        direction = 'float',
        float_opts = {
            border = 'curved',
        },
        -- function to run on opening the terminal
        on_open = function(term)
            vim.cmd('startinsert!')
            -- vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        -- function to run on closing the terminal
        on_close = function(term)
            vim.cmd('startinsert!')
        end,
    })

    function _lf_toggle()
        lf:toggle()
    end
end

return M
