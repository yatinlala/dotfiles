return {
    'olimorris/codecompanion.nvim',
    keys = {
        { '<C-a>', '<cmd>CodeCompanionActions<cr>' },
        { 'v', '<C-a>', '<cmd>CodeCompanionActions<cr>', mode = 'v' },
        { '<LocalLeader>a', '<cmd>CodeCompanionToggle<cr>' },
        { '<LocalLeader>a', '<cmd>CodeCompanionToggle<cr>', mode = 'v' },
        { 'ga', '<cmd>CodeCompanionAdd<cr>', mode = 'v' },
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
        'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
        { 'stevearc/dressing.nvim', opts = {} }, -- Optional: Improves the default Neovim UI
    },
    config = function()
        -- Expand 'cc' into 'CodeCompanion' in the command line
        vim.cmd([[cab cc CodeCompanion]])
        require('codecompanion').setup({
            adapters = {
                openai = function()
                    return require('codecompanion.adapters').extend('openai', {
                        env = {
                            api_key = 'cmd:pass show codecompanion-openai',
                        },
                    })
                end,
            },
        })
    end,
}
