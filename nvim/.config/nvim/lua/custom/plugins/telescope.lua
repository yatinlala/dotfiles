return { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    keys = { '<leader>f' },
    cmd = 'Telescope',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
            'nvim-telescope/telescope-fzf-native.nvim',

            -- `build` is used to run some command when the plugin is installed/updated.
            -- This is only run then, not every time Neovim starts up.
            build = 'make',

            -- `cond` is a condition used to determine whether this plugin should be
            -- installed and loaded.
            cond = function()
                return vim.fn.executable('make') == 1
            end,
        },
        -- This is handled by dressing.nvim
        -- { 'nvim-telescope/telescope-ui-select.nvim' },

        -- Useful for getting pretty icons, but requires a Nerd Font.
        { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
        -- Two important keymaps to use while in Telescope are:
        --  - Insert mode: <c-/>
        --  - Normal mode: ?
        --
        -- This opens a window that shows you all of the keymaps for the current
        -- Telescope picker. This is really useful to discover what Telescope can
        -- do as well as how to actually do it!

        -- [[ Configure Telescope ]]
        -- See `:help telescope` and `:help telescope.setup()`
        require('telescope').setup({
            -- You can put your default mappings / updates / etc. in here
            --  All the info you're looking for is in `:help telescope.setup()`
            --
            -- defaults = {
            --   mappings = {
            --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
            --   },
            -- },
            -- pickers = {}
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
            },
        })

        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        -- See `:help telescope.builtin`
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[f]ind [h]elp' })
        vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[f]ind [k]eymaps' })
        vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'find files' })
        vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[f]ind [s]elect Telescope' })
        vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[f]ind current [w]ord' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[f]ind by [g]rep' })
        vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[f]ind [d]iagnostics' })
        vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[f]ind [r]esume' })
        vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[f]ind recent Files ("." for repeat)' })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'find existing buffers' })

        -- Slightly advanced example of overriding default behavior and theme
        vim.keymap.set('n', '<leader>/', function()
            -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
                winblend = 10,
                previewer = false,
            }))
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        vim.keymap.set('n', '<leader>f/', function()
            builtin.live_grep({
                grep_open_files = true,
                prompt_title = 'live grep in open files',
            })
        end, { desc = '[f]ind [/] in open files' })

        -- Shortcut for searching your Neovim configuration files
        vim.keymap.set('n', '<leader>fn', function()
            builtin.find_files({ cwd = vim.fn.stdpath('config') })
        end, { desc = '[f]ind [n]eovim files' })
    end,
}

-- local M = {
--     'nvim-telescope/telescope.nvim',
--     cmd = { 'Telescope' },
--     dependencies = {
--         { 'nvim-lua/plenary.nvim' },
--         { 'nvim-tree/nvim-web-devicons' },
--         { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
--         { 'debugloop/telescope-undo.nvim' },
--         { 'nvim-telescope/telescope-project.nvim' },
--     },
-- }
--
-- function M.config()
--     -- local trouble = require("trouble.providers.telescope")
--     local telescope = require('telescope')
--
--     require('telescope').setup({
--         defaults = {
--             mappings = {
--                 i = {
--                     -- ['<CR>'] = require('telescope.actions').select_tab,
--                     -- ['<C-t>'] = require('telescope.actions').select_default,
--                 },
--             },
--             prompt_prefix = '  ',
--             selection_caret = ' ',
--             file_ignore_patterns = {
--                 '.git/',
--                 '.cache',
--                 'node_modules',
--                 '%.o',
--                 '%.a',
--                 '%.out',
--                 '%.class',
--                 '%.pdf',
--                 '%.mkv',
--                 '%.mp4',
--                 '%.zip',
--             },
--         },
--
--         pickers = {
--             find_files = {
--                 follow = true, -- follow symlinks
--                 hidden = true, -- include hidden files
--             },
--         },
--         extensions = {
--             fzf = {
--                 fuzzy = true, -- false will only do exact matching
--                 override_generic_sorter = true, -- override the generic sorter
--                 override_file_sorter = true, -- override the file sorter
--                 case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
--             },
--         },
--     })
--     -- To get fzf loaded and working with telescope, you need to call
--     -- load_extension, somewhere after setup function:
--     require('telescope').load_extension('fzf')
--     require('telescope').load_extension('projects')
--     require('telescope').load_extension('undo')
-- end
--
-- return M
