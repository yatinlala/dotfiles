return {
    'nvim-telescope/telescope.nvim',
    enabled = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'echasnovski/mini.icons',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    cmd = 'Telescope',
    keys = {
        { '<leader>f', '<cmd>Telescope find_files<CR>', { desc = 'Find [F]iles' } },
        { '<leader>h', '<cmd>Telescope help_tags<CR>', { desc = 'Find [H]elp' } },
        { '<leader>G', '<cmd>Telescope live_grep<CR>', { desc = 'Live [G]rep' } },
        -- { '<leader><leader>', '<cmd>Telescope buffers theme=dropdown<CR>', { desc = 'Find Buffers' } },
        -- { '<leader>fk', function() require('telescope.builtin').keymaps end, { desc = '[f]ind [k]eymaps'} },
        -- { '<leader>fs', function() require('telescope.builtin').builtin end, { desc = '[f]ind [s]elect Telescope'} },
        -- { '<leader>fw', function() require('telescope.builtin').grep_string end, { desc = '[f]ind current [w]ord'} },
        -- { '<leader>fd', function() require('telescope.builtin').diagnostics end, { desc = '[f]ind [d]iagnostics'} },
        -- { '<leader>fr', function() require('telescope.builtin').resume end, { desc = '[f]ind [r]esume'} },
        -- { '<leader>f.', function() require('telescope.builtin').oldfiles end, { desc = '[f]ind recent Files ("." for repeat)'} },
    },
    config = function()
        require('telescope').setup({
            defaults = {
                prompt_prefix = '  ',
                selection_caret = ' ',
                file_ignore_patterns = {
                    '.git/',
                    '.cache',
                    'node_modules',
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
            extensions = { fzf = {} },
            pickers = {
                find_files = {
                    follow = true, -- follow symlinks
                    hidden = true, -- include hidden files
                },
            },
        })
        require('telescope').load_extension('fzf')
    end,
}
--     opts = {
--         pickers = {
--             find_files = {
--                 layout_config = {
--                     prompt_position = 'top',
--                 },
--                 sorting_strategy = 'ascending',
--             },
--         },
--
--         defaults = {
--             prompt_prefix = '  ',
--             selection_caret = ' ',
--         },
--     },
-- }
--
-- return { -- Fuzzy Finder (files, lsp, etc)
--     'nvim-telescope/telescope.nvim',
--     cmd = 'Telescope',
--     dependencies = {
--         'nvim-lua/plenary.nvim',
--         { -- If encountering errors, see telescope-fzf-native README for installation instructions
--             'nvim-telescope/telescope-fzf-native.nvim',
--
--             -- `build` is used to run some command when the plugin is installed/updated.
--             -- This is only run then, not every time Neovim starts up.
--             build = 'make',
--
--             -- `cond` is a condition used to determine whether this plugin should be
--             -- installed and loaded.
--             cond = function()
--                 return vim.fn.executable('make') == 1
--             end,
--         },
--         -- This is handled by dressing.nvim
--         -- { 'nvim-telescope/telescope-ui-select.nvim' },
--
--         -- Useful for getting pretty icons, but requires a Nerd Font.
--         { 'nvim-tree/nvim-web-devicons' },
--     },
--     config = function()
--         -- Two important keymaps to use while in Telescope are:
--         --  - Insert mode: <c-/>
--         --  - Normal mode: ?
--         --
--         -- This opens a window that shows you all of the keymaps for the current
--         -- Telescope picker. This is really useful to discover what Telescope can
--         -- do as well as how to actually do it!
--
--         -- [[ Configure Telescope ]]
--         -- See `:help telescope` and `:help telescope.setup()`
--         require('telescope').setup({
--             -- You can put your default mappings / updates / etc. in here
--             --  All the info you're looking for is in `:help telescope.setup()`
--             --
--             -- defaults = {
--             --   mappings = {
--             --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
--             --   },
--             -- },
--             -- pickers = {} extensions = {
--                 ['ui-select'] = {
--                     require('telescope.themes').get_dropdown(),
--                 },
--             },
--         })
--
--         -- Enable Telescope extensions if they are installed
--         pcall(require('telescope').load_extension, 'fzf')
--         pcall(require('telescope').load_extension, 'ui-select')
--
--
--         -- Slightly advanced example of overriding default behavior and theme
--         vim.keymap.set('n', '<leader>/', function()
--             -- You can pass additional configuration to Telescope to change the theme, layout, etc.
--             builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
--                 winblend = 10,
--                 previewer = false,
--             }))
--         end, { desc = '[/] Fuzzily search in current buffer' })
--
--         -- It's also possible to pass additional configuration options.
--         --  See `:help telescope.builtin.live_grep()` for information about particular keys
--         vim.keymap.set('n', '<leader>f/', function()
--             builtin.live_grep({
--                 grep_open_files = true,
--                 prompt_title = 'live grep in open files',
--             })
--         end, { desc = '[f]ind [/] in open files' })
--
--         -- Shortcut for searching your Neovim configuration files
--         vim.keymap.set('n', '<leader>fn', function()
--             builtin.find_files({ cwd = vim.fn.stdpath('config') })
--         end, { desc = '[f]ind [n]eovim files' })
--     end,
-- }
--
-- -- local M = {
-- --     'nvim-telescope/telescope.nvim',
-- --     cmd = { 'Telescope' },
-- --     dependencies = {
-- --         { 'nvim-lua/plenary.nvim' },
-- --         { 'nvim-tree/nvim-web-devicons' },
-- --         { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
-- --         { 'debugloop/telescope-undo.nvim' },
-- --         { 'nvim-telescope/telescope-project.nvim' },
-- --     },
-- -- }
-- --
-- -- function M.config()
-- --     -- local trouble = require("trouble.providers.telescope")
-- --     local telescope = require('telescope')
-- --
-- --     -- To get fzf loaded and working with telescope, you need to call
-- --     -- load_extension, somewhere after setup function:
-- --     require('telescope').load_extension('fzf')
-- --     require('telescope').load_extension('projects')
-- --     require('telescope').load_extension('undo')
-- -- end
-- --
-- -- return M
