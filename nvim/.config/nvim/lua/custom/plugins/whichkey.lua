return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
        local wk = require('which-key')

        wk.setup({ preset = 'helix' })

        wk.add({
            { '<leader>f', group = '[F]ind' }, -- group
            { '<leader>g', group = '[G]it' },  -- group
            { '<leader>o', group = '[O]rg Mode' }, -- group
            { '<leader>l', group = '[L]sp' },  -- group
            { '<leader>t', group = '[T]reesitter' }, -- group
            --     ['<leader>d'] = { name = 'document', _ = 'which_key_ignore' },
            --     ['<leader>r'] = { name = 'rename', _ = 'which_key_ignore' },
            --     ['<leader>l'] = { name = 'lsp', _ = 'which_key_ignore' },
            --     ['<leader>w'] = { name = 'workspace', _ = 'which_key_ignore' },
        })
    end,
}
