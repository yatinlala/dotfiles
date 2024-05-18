-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float, { desc = 'show diagnostic error' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'open diagnostic quickfix' })
-- these two are now default w/ 0.10
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'previous diagnostic' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'next diagnostic' })

-- exit terminal mode
-- vim.keymap.set('t', 'JK', '<C-\\><C-n>', { desc = 'exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'focus left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'focus right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'focus lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'focus upper window' })

local opts = { noremap = true, silent = true }

-- Navigate buffers
vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', opts)
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<CR>', opts)

-- Lf
vim.keymap.set('n', '<leader>e', '<cmd>Lf ' .. vim.fn.expand('%') .. '<CR>', { desc = 'open lf' })

-- Git
vim.keymap.set('n', '<leader>gg', '<cmd>Lazygit<CR>', { desc = 'open lazygit' })
vim.keymap.set('n', '<leader>gj', "<cmd>lua require('gitsigns').next_hunk()<CR>", { desc = 'next hunk' })
vim.keymap.set('n', '<leader>gk', "<cmd>lua require('gitsigns').prev_hunk()<CR>", { desc = 'previous hunk' })
vim.keymap.set('n', '<leader>gl', "<cmd>lua require('gitsigns').blame_line()<CR>", { desc = 'blame line' })
vim.keymap.set('n', '<leader>gp', "<cmd>lua require('gitsigns').blame_line()<CR>", { desc = 'blame line' })
vim.keymap.set('n', '<leader>gr', "<cmd>lua require('gitsigns').reset_hunk()<CR>", { desc = 'reset hunk' })
--         p = { function() require('gitsigns').preview_hunk() end, 'Preview Hunk', },
--         R = { function() require('gitsigns').reset_buffer() end, 'Reset Buffer', },
--         s = { function() require('gitsigns').stage_hunk() end, 'Stage Hunk', },
--         u = { function() require('gitsigns').undo_stage_hunk() end, 'Undo Stage Hunk', },
--         o = { '<cmd>Telescope git_status<cr>', 'Open changed file' },
--         b = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
--         c = { '<cmd>Telescope git_commits<cr>', 'Checkout commit' },
--         d = { '<cmd>Gitsigns diffthis HEAD<cr>', 'Diff', }, 
--         d = { "<cmd>DiffviewOpen<cr>", "DiffView" },

-- Codeium
vim.keymap.set('n', '<leader>a', '<cmd>CodeiumToggle<CR>', { desc = 'toggle codeium' })

-- local wk = require('which-key')
--
-- -- Normal --
--
-- -- Clear search highlights
-- vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<CR><esc>')
--
-- -- Don't yank on x
-- -- vim.keymap.set('n', 'x', '"_x', opts)
-- vim.keymap.set('n', '<leader><leader>d', [["_d]], opts)
--
-- -- Sensible split movement
-- -- vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
-- -- vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
-- -- vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
-- -- vim.keymap.set('n', '<C-l>', '<C-w>l', opts)
--
-- -- Centered searches
-- vim.keymap.set('n', 'n', 'nzzzv', opts)
-- vim.keymap.set('n', 'N', 'Nzzzv', opts)
-- -- -- Centered half page movements
-- -- vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
-- -- vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
-- -- Centered line cat
-- vim.keymap.set('n', 'J', "mzJ'z", opts)
-- -- Centered search
-- vim.cmd([[
--     nnoremap <C-o> <C-o>zvzz
--     nnoremap <C-i> <C-i>zvzz
--
--     cnoremap <silent><expr> <enter> index(['/', '?'], getcmdtype()) >= 0 ? '<enter>zvzz' : '<enter>'
-- ]])
--
-- vim.keymap.set('n', '<c-\\>', '<cmd>ToggleTerm<CR>', opts)
--
-- vim.keymap.set('n', 'gf', '<cmd>e <cfile><CR>', opts)
--
-- -- -- Smart(ish) compilation
-- -- vim.keymap.set('n', '<leader>c',  '<cmd>w! \\| !comp <c-r>%<CR><CR>', {})
-- -- -- Enable spell checking
-- -- vim.keymap.set('n', '<leader><leader>s', '<cmd>setlocal spell! spelllang=en_us<CR>', {})
--
-- -- Insert --
-- -- Undo break points
-- vim.keymap.set('i', ',', ',<c-g>u', opts)
-- vim.keymap.set('i', '.', '.<c-g>u', opts)
-- vim.keymap.set('i', '(', '(<c-g>u', opts)
--
-- -- Adjust bullet level
-- vim.keymap.set('i', '<C-g>', '<esc><<A', opts)
-- vim.keymap.set('i', '<C-h>', '<esc>>>A', opts)
--
-- vim.keymap.set('i', '<C-<BS>>', '<C-w>', opts)
--
-- -- Visual --
-- -- Stay in indent mode
-- vim.keymap.set('v', '<', '<gv', opts)
-- vim.keymap.set('v', '>', '>gv', opts)
--
-- -- Don't override copy register when pasting into highlight
-- vim.keymap.set('v', 'p', '"_dP', opts)
--
-- -- Visual Block --
-- -- Move text up and down and indent it
-- vim.keymap.set('x', 'J', "<cmd>move '>+1<CR>gv=gv", opts)
-- vim.keymap.set('x', 'K', "<cmd>move '<-2<CR>gv=gv", opts)
--
-- -- Command --
-- -- Force save a sudoer file
-- vim.keymap.set('c', 'w!!', 'w !sudo tee %', {})
--
-- wk.register({
--     a = {
--         function()
--             require('chatgpt').edit_with_instructions()
--         end,
--         'Chatgpt Edit with instructions',
--     },
-- }, {
--     prefix = '<leader>',
--     mode = 'v',
-- })
-- local leader = {
--     -- [' '] = {
--     --     name = 'splitjoin',
--     --     j = '<cmd>TSJSplit', 'split',
--     --     s = '<cmd>TSJJoin', 'join',
--     -- },
--     a = {
--         name = 'ChatGPT',
--         c = { '<cmd>ChatGPT<CR>', 'ChatGPT' },
--         e = { '<cmd>ChatGPTEditWithInstruction<CR>', 'Edit with instruction', mode = { 'n', 'v' } },
--         g = { '<cmd>ChatGPTRun grammar_correction<CR>', 'Grammar Correction', mode = { 'n', 'v' } },
--         t = { '<cmd>ChatGPTRun translate<CR>', 'Translate', mode = { 'n', 'v' } },
--         k = { '<cmd>ChatGPTRun keywords<CR>', 'Keywords', mode = { 'n', 'v' } },
--         d = { '<cmd>ChatGPTRun docstring<CR>', 'Docstring', mode = { 'n', 'v' } },
--         a = { '<cmd>ChatGPTRun add_tests<CR>', 'Add Tests', mode = { 'n', 'v' } },
--         o = { '<cmd>ChatGPTRun optimize_code<CR>', 'Optimize Code', mode = { 'n', 'v' } },
--         s = { '<cmd>ChatGPTRun summarize<CR>', 'Summarize', mode = { 'n', 'v' } },
--         f = { '<cmd>ChatGPTRun fix_bugs<CR>', 'Fix Bugs', mode = { 'n', 'v' } },
--         x = { '<cmd>ChatGPTRun explain_code<CR>', 'Explain Code', mode = { 'n', 'v' } },
--         r = { '<cmd>ChatGPTRun roxygen_edit<CR>', 'Roxygen Edit', mode = { 'n', 'v' } },
--         l = { '<cmd>ChatGPTRun code_readability_analysis<CR>', 'Code Readability Analysis', mode = { 'n', 'v' } },
--     },
--     b = {
--         function()
--             require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({ previewer = false }))
--         end,
--         'buffers',
--     },
--     B = { '<cmd>Barbecue toggle<CR>', 'toggle barbecue' },
--     C = { require('util').toggleBg, 'toggle dark/light' },
--     D = {
--         name = 'Duck',
--         h = { "<cmd>lua require('duck').hatch()<CR>", 'Hatch a duck' },
--         k = { "<cmd>require('duck').cook()<CR>", 'Cook the duck' },
--     },
--     f = {
--         name = 'Telescope',
--         b = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
--         B = { '<cmd>Telescope current_buffer_fuzzy_find<cr>', 'Buffer' },
--         c = { '<cmd>Telescope commands<cr>', 'Commands' },
--         h = { '<cmd>Telescope help_tags<CR>', 'help tags' },
--         k = { '<cmd>Telescope keymaps<cr>', 'Keymaps' },
--         m = { '<cmd>Telescope man_pages<cr>', 'Man Pages' },
--         u = { '<cmd>Telescope undo<cr>', 'Undo' },
--         n = { '<cmd>Telescope find_files cwd=~/.config/nvim<CR>', 'edit neovim' },
--         p = { "<cmd>lua require('telescope').extensions.projects.projects<CR>", 'projects' },
--         r = { '<cmd>Telescope oldfiles<CR>', 'recent files' },
--         R = { '<cmd>Telescope registers<cr>', 'Registers' },
--         s = {
--             function()
--                 require('telescope.builtin').symbols({ sources = { 'emoji', 'kaomoji', 'gitmoji' } })
--             end,
--             'recent files',
--         },
--
--         [':'] = { ':Telescope command_history<cr>', 'Command History' },
--         t = { '<cmd>Telescope builtin<cr>', 'Telescope' },
--         S = { '<cmd>Telescope highlights<cr>', 'Search Highlight Groups' },
--         l = { vim.show_pos, 'Highlight Groups at cursor' },
--         f = { '<cmd>Telescope filetypes<cr>', 'File Types' },
--         o = { '<cmd>Telescope vim_options<cr>', 'Options' },
--         a = { '<cmd>Telescope autocommands<cr>', 'Auto Commands' },
--     },
--     ['/'] = { '<cmd>Telescope live_grep theme=ivy<cr>', 'Find Text' },
--     -- ["."] = { "<cmd>Telescope file_browser<CR>", "Browse Files" },
--     ['.'] = { '<cmd>Telescope file_browser<CR>', 'Browse Files' },
--     l = {
--         name = 'LSP',
--         -- a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
--         c = {
--             function()
--                 require('codeium').setup({})
--             end,
--             'Activate Codeium',
--         },
--         d = {
--             '<cmd>Telescope lsp_document_diagnostics<cr>',
--             'Document Diagnostics',
--         },
--         w = {
--             '<cmd>Telescope lsp_workspace_diagnostics<cr>',
--             'Workspace Diagnostics',
--         },
--         i = { '<cmd>LspInfo<cr>', 'Info' },
--         I = { '<cmd>LspInstallInfo<cr>', 'Installer Info' },
--         j = {
--             function()
--                 vim.lsp.diagnostic.goto_next()
--             end,
--             'Next Diagnostic',
--         },
--         k = {
--             function()
--                 vim.lsp.diagnostic.goto_prev()
--             end,
--             'Prev Diagnostic',
--         },
--         l = {
--             function()
--                 vim.lsp.codelens.run()
--             end,
--             'CodeLens Action',
--         },
--         m = { '<cmd>TSJToggle<CR>', 'Join/Split' },
--         o = { '<cmd>SymbolsOutline<CR>', 'Symbols Outline' },
--         q = {
--             function()
--                 vim.diagnostic.setloclist({ open = false })
--             end,
--             'Quickfix',
--         },
--         r = {
--             function()
--                 vim.lsp.buf.rename()
--             end,
--             'Rename',
--         },
--         s = { '<cmd>Telescope lsp_document_symbols<cr>', 'Document Symbols' },
--         S = {
--             '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>',
--             'Workspace Symbols',
--         },
--     },
--     L = { '<cmd>Lazy<cr>', 'Lazy' },
--     m = { '<cmd>Mason<cr>', 'Mason' },
--     n = {
--         '<cmd>ene <BAR> startinsert <CR>',
--         'new file',
--     },
--     o = {
--         function()
--             vim.ui.open(vim.fn.expand('%'))
--         end,
--         'vim.open file',
--     },
--     q = {
--         name = 'Quickfix',
--         l = { '<cmd>lopen<cr>', 'Open Location List' },
--         q = { '<cmd>copen<cr>', 'Open Quickfix List' },
--     },
--     t = {
--         name = 'Terminal',
--         f = { '<cmd>ToggleTerm direction=float<cr>', 'Term Float' },
--         h = { '<cmd>ToggleTerm size=10 direction=horizontal<cr>', 'Term Horizontal' },
--         -- p = { _PYTHON_TOGGLE(), "Python" },
--         t = { '<cmd>ToggleTerm direction=tab<cr>', 'Term Tab' },
--         v = { '<cmd>ToggleTerm size=80 direction=vertical<cr>', 'Term Vertical' },
--     },
--     u = {
--         '<cmd>Telescope undo<CR>',
--         'Undo',
--     },
--     --   t = {
--     --     name = "toggle",
--     --     f = {
--     --       require("config.plugins.lsp.formatting").toggle,
--     --       "Format on Save",
--     --     },
--     --     s = {
--     --       function()
--     --         util.toggle("spell")
--     --       end,
--     --       "Spelling",
--     --     },
--     --     w = {
--     --       function()
--     --         util.toggle("wrap")
--     --       end,
--     --       "Word Wrap",
--     --     },
--     --     n = {
--     --       function()
--     --         util.toggle("relativenumber", true)
--     --         util.toggle("number")
--     --       end,
--     --       "Line Numbers",
--     --     },
--     --   },
--     --   ["<tab>"] = {
--     --     name = "tabs",
--     --     ["<tab>"] = { "<cmd>tabnew<CR>", "New Tab" },
--     --     n = { "<cmd>tabnext<CR>", "Next" },
--     --     d = { "<cmd>tabclose<CR>", "Close" },
--     --     p = { "<cmd>tabprevious<CR>", "Previous" },
--     --     ["]"] = { "<cmd>tabnext<CR>", "Next" },
--     --     ["["] = { "<cmd>tabprevious<CR>", "Previous" },
--     --     f = { "<cmd>tabfirst<CR>", "First" },
--     --     l = { "<cmd>tablast<CR>", "Last" },
--     --   },
-- }
--
-- wk.register(leader, { prefix = '<leader>' })
--
-- wk.register({ g = { name = '+goto' } })
