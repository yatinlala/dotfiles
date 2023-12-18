local M = {
    'nvim-telescope/telescope.nvim',
    cmd = { 'Telescope' },
    cond = not vim.ui.vscode,
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-tree/nvim-web-devicons' },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        { 'debugloop/telescope-undo.nvim' },
        { 'nvim-telescope/telescope-project.nvim' },
    },
}

function M.config()
    -- local trouble = require("trouble.providers.telescope")
    local telescope = require('telescope')

    require('telescope').setup({
        defaults = {
            prompt_prefix = '  ',
            selection_caret = ' ',
            file_ignore_patterns = {
                '.git/',
                '.cache',
                '%.o',
                '%.a',
                '%.out',
                '%.class',
                '%.pdf',
                '%.mkv',
                '%.mp4',
                '%.zip',
            },
        },

        pickers = {
            find_files = {
                follow = true, -- follow symlinks
                hidden = true, -- include hidden files
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,                   -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true,    -- override the file sorter
                case_mode = 'smart_case',       -- or "ignore_case" or "respect_case"
            },
        },
    })
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('projects')
    require('telescope').load_extension('undo')
end

return M
