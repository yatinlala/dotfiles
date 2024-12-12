-- [[ Basic Keymaps ]]

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<M-h>', '<C-w><', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<M-l>', '<C-w>>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<M-j>', '<C-w>-', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<M-k>', '<C-w>+', { desc = 'Move focus to the upper window' })

-- File Explorer
vim.keymap.set('n', '<leader>e', function()
    vim.cmd('Lf ' .. '"' .. vim.fn.expand('%') .. '"')
end, { desc = 'Open Lf' })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

vim.keymap.set('n', '<C-n>', function()
    vim.opt.number = not vim.opt.number:get()
end, { desc = 'Toggle number' })

vim.keymap.set('n', '<C-s>', function()
    if vim.opt.laststatus:get() == 0 then
        vim.opt.laststatus = 3
    else
        vim.opt.laststatus = 0
    end
end, { desc = 'Toggle statusline' })

-- Source things
vim.keymap.set('n', '<leader>X', '<cmd>source %<CR>', { desc = 'Source file' })
vim.keymap.set('n', '<leader>x', '<cmd>.lua<CR>', { desc = 'Source line' })
vim.keymap.set('v', '<leader>x', '<cmd>lua<CR>', { desc = 'Source selection' })

-- Navigate buffers
vim.keymap.set('n', '<leader>x', '<cmd>e #<CR>', { desc = 'Alternate buffer' }) -- same as C-6 (^)
-- vim.keymap.set('n', '[[', '<cmd>bnext<CR>')
-- vim.keymap.set('n', '<S-h>', '<cmd>bprevious<CR>')

-- exit terminal mode
vim.keymap.set('t', 'JK', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Visual --
local opts = { noremap = true, silent = true }
-- Stay in indent mode
-- note: i removed this because i should be using . repeat instead of spamming >
-- vim.keymap.set('v', '<', '<gv', opts)
-- vim.keymap.set('v', '>', '>gv', opts)

-- Open Files
-- vim.keymap.set('n', '<leader>f', ':find ', { desc = '[F]ind file' })
-- vim.keymap.set('n', ',f', ':find *', { desc = '[F]ind file' })
-- vim.keymap.set('n', ',s', ':sfind *', { desc = '[S]plit find file' })
-- vim.keymap.set('n', ',v', ':vert :sfind *', { desc = '[V]ertical split find file' })
-- vim.keymap.set('n', ',t', ':tabfind *', { desc = 'Find file in new [T]ab' })
-- nnoremap ,F :find <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
-- nnoremap ,S :sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
-- nnoremap ,V :vert sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
-- nnoremap ,T :tabfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
-- vim.cmd([[
--     nnoremap gb :ls<CR>:buffer<Space>
--     nnoremap gB :ls<CR>:sbuffer<Space>
--     nnoremap ,b :buffer *
--     nnoremap ,B :sbuffer *
--     " autoexpansion
--     "inoremap (<CR> (<CR>)<Esc>O
--     "inoremap {<CR> {<CR>}<Esc>O
--     "inoremap {; {<CR>};<Esc>O
--     "inoremap {, {<CR>},<Esc>O
--     "inoremap [<CR> [<CR>]<Esc>O
--     "inoremap [; [<CR>];<Esc>O
--     "inoremap [, [<CR>],<Esc>O
-- ]])

-- -- Diagnostic keymaps
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float, { desc = 'show diagnostic error' })
--
-- -- these two are now default w/ 0.10
-- -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'previous diagnostic' })
-- -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'next diagnostic' })
--
--
--
--
-- -- Git
-- vim.keymap.set('n', '<leader>gg', '<cmd>Lazygit<CR>', { desc = 'open lazygit' })
-- --         o = { '<cmd>Telescope git_status<cr>', 'Open changed file' },
-- --         b = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
-- --         c = { '<cmd>Telescope git_commits<cr>', 'Checkout commit' },
-- --         d = { '<cmd>Gitsigns diffthis HEAD<cr>', 'Diff', },
-- --         d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
--
-- -- Codeium
-- vim.keymap.set('n', '<leader>a', '<cmd>CodeiumToggle<CR>', { desc = 'toggle codeium' })
--
--
-- -- local wk = require('which-key')
-- --
-- -- -- Normal --
-- --
-- -- -- Clear search highlights
-- -- vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<CR><esc>')
-- --
-- -- -- Don't yank on x
-- -- -- vim.keymap.set('n', 'x', '"_x', opts)
-- -- vim.keymap.set('n', '<leader><leader>d', [["_d]], opts)
-- --
-- -- -- Sensible split movement
-- -- -- vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
-- -- -- vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
-- -- -- vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
-- -- -- vim.keymap.set('n', '<C-l>', '<C-w>l', opts)
-- --
-- -- -- Centered searches
-- -- vim.keymap.set('n', 'n', 'nzzzv', opts)
-- -- vim.keymap.set('n', 'N', 'Nzzzv', opts)
-- -- -- -- Centered half page movements
-- -- -- vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
-- -- -- vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
-- -- -- Centered line cat
-- -- vim.keymap.set('n', 'J', "mzJ'z", opts)
-- -- -- Centered search
-- -- vim.cmd([[
-- --     nnoremap <C-o> <C-o>zvzz
-- --     nnoremap <C-i> <C-i>zvzz
-- --
-- --     cnoremap <silent><expr> <enter> index(['/', '?'], getcmdtype()) >= 0 ? '<enter>zvzz' : '<enter>'
-- -- ]])
-- --
-- -- vim.keymap.set('n', '<c-\\>', '<cmd>ToggleTerm<CR>', opts)
-- --
-- -- vim.keymap.set('n', 'gf', '<cmd>e <cfile><CR>', opts)
-- --
-- -- -- -- Smart(ish) compilation
-- -- -- vim.keymap.set('n', '<leader>c',  '<cmd>w! \\| !comp <c-r>%<CR><CR>', {})
-- -- -- -- Enable spell checking
-- -- -- vim.keymap.set('n', '<leader><leader>s', '<cmd>setlocal spell! spelllang=en_us<CR>', {})
-- --
-- -- -- Insert --
-- -- -- Undo break points
-- -- vim.keymap.set('i', ',', ',<c-g>u', opts)
-- -- vim.keymap.set('i', '.', '.<c-g>u', opts)
-- -- vim.keymap.set('i', '(', '(<c-g>u', opts)
-- --
-- -- -- Adjust bullet level
-- -- vim.keymap.set('i', '<C-g>', '<esc><<A', opts)
-- -- vim.keymap.set('i', '<C-h>', '<esc>>>A', opts)
-- --
-- -- vim.keymap.set('i', '<C-<BS>>', '<C-w>', opts)
-- --
-- --
-- -- -- Don't override copy register when pasting into highlight
-- -- vim.keymap.set('v', 'p', '"_dP', opts)
-- --
-- -- -- Visual Block --
-- -- -- Move text up and down and indent it
-- -- vim.keymap.set('x', 'J', "<cmd>move '>+1<CR>gv=gv", opts)
-- -- vim.keymap.set('x', 'K', "<cmd>move '<-2<CR>gv=gv", opts)
-- --
-- -- -- Command --
-- -- -- Force save a sudoer file
-- -- vim.keymap.set('c', 'w!!', 'w !sudo tee %', {})
-- --
-- -- wk.register({
-- --     a = {
-- --         function()
-- --             require('chatgpt').edit_with_instructions()
-- --         end,
-- --         'Chatgpt Edit with instructions',
-- --     },
-- -- }, {
-- --     prefix = '<leader>',
-- --     mode = 'v',
-- -- })
-- -- local leader = {
-- --     -- [' '] = {
-- --     --     name = 'splitjoin',
-- --     --     j = '<cmd>TSJSplit', 'split',
-- --     --     s = '<cmd>TSJJoin', 'join',
-- --     -- },
-- --     a = {
-- --         name = 'ChatGPT',
-- --         c = { '<cmd>ChatGPT<CR>', 'ChatGPT' },
-- --         e = { '<cmd>ChatGPTEditWithInstruction<CR>', 'Edit with instruction', mode = { 'n', 'v' } },
-- --         g = { '<cmd>ChatGPTRun grammar_correction<CR>', 'Grammar Correction', mode = { 'n', 'v' } },
-- --         t = { '<cmd>ChatGPTRun translate<CR>', 'Translate', mode = { 'n', 'v' } },
-- --         k = { '<cmd>ChatGPTRun keywords<CR>', 'Keywords', mode = { 'n', 'v' } },
-- --         d = { '<cmd>ChatGPTRun docstring<CR>', 'Docstring', mode = { 'n', 'v' } },
-- --         a = { '<cmd>ChatGPTRun add_tests<CR>', 'Add Tests', mode = { 'n', 'v' } },
-- --         o = { '<cmd>ChatGPTRun optimize_code<CR>', 'Optimize Code', mode = { 'n', 'v' } },
-- --         s = { '<cmd>ChatGPTRun summarize<CR>', 'Summarize', mode = { 'n', 'v' } },
-- --         f = { '<cmd>ChatGPTRun fix_bugs<CR>', 'Fix Bugs', mode = { 'n', 'v' } },
-- --         x = { '<cmd>ChatGPTRun explain_code<CR>', 'Explain Code', mode = { 'n', 'v' } },
-- --         r = { '<cmd>ChatGPTRun roxygen_edit<CR>', 'Roxygen Edit', mode = { 'n', 'v' } },
-- --         l = { '<cmd>ChatGPTRun code_readability_analysis<CR>', 'Code Readability Analysis', mode = { 'n', 'v' } },
-- --     },
-- --     b = {
-- --         function()
-- --             require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({ previewer = false }))
-- --         end,
-- --         'buffers',
-- --     },
-- --     B = { '<cmd>Barbecue toggle<CR>', 'toggle barbecue' },
-- --     C = { require('util').toggleBg, 'toggle dark/light' },
-- --     D = {
-- --         name = 'Duck',
-- --         h = { "<cmd>lua require('duck').hatch()<CR>", 'Hatch a duck' },
-- --         k = { "<cmd>require('duck').cook()<CR>", 'Cook the duck' },
-- --     },
-- --     f = {
-- --         name = 'Telescope',
-- --         b = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
-- --         B = { '<cmd>Telescope current_buffer_fuzzy_find<cr>', 'Buffer' },
-- --         c = { '<cmd>Telescope commands<cr>', 'Commands' },
-- --         h = { '<cmd>Telescope help_tags<CR>', 'help tags' },
-- --         k = { '<cmd>Telescope keymaps<cr>', 'Keymaps' },
-- --         m = { '<cmd>Telescope man_pages<cr>', 'Man Pages' },
-- --         u = { '<cmd>Telescope undo<cr>', 'Undo' },
-- --         n = { '<cmd>Telescope find_files cwd=~/.config/nvim<CR>', 'edit neovim' },
-- --         p = { "<cmd>lua require('telescope').extensions.projects.projects<CR>", 'projects' },
-- --         r = { '<cmd>Telescope oldfiles<CR>', 'recent files' },
-- --         R = { '<cmd>Telescope registers<cr>', 'Registers' },
-- --         s = {
-- --             function()
-- --                 require('telescope.builtin').symbols({ sources = { 'emoji', 'kaomoji', 'gitmoji' } })
-- --             end,
-- --             'recent files',
-- --         },
-- --
-- --         [':'] = { ':Telescope command_history<cr>', 'Command History' },
-- --         t = { '<cmd>Telescope builtin<cr>', 'Telescope' },
-- --         S = { '<cmd>Telescope highlights<cr>', 'Search Highlight Groups' },
-- --         l = { vim.show_pos, 'Highlight Groups at cursor' },
-- --         f = { '<cmd>Telescope filetypes<cr>', 'File Types' },
-- --         o = { '<cmd>Telescope vim_options<cr>', 'Options' },
-- --         a = { '<cmd>Telescope autocommands<cr>', 'Auto Commands' },
-- --     },
-- --     ['/'] = { '<cmd>Telescope live_grep theme=ivy<cr>', 'Find Text' },
-- --     -- ["."] = { "<cmd>Telescope file_browser<CR>", "Browse Files" },
-- --     ['.'] = { '<cmd>Telescope file_browser<CR>', 'Browse Files' },
-- --     l = {
-- --         name = 'LSP',
-- --         -- a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
-- --         c = {
-- --             function()
-- --                 require('codeium').setup({})
-- --             end,
-- --             'Activate Codeium',
-- --         },
-- --         d = {
-- --             '<cmd>Telescope lsp_document_diagnostics<cr>',
-- --             'Document Diagnostics',
-- --         },
-- --         w = {
-- --             '<cmd>Telescope lsp_workspace_diagnostics<cr>',
-- --             'Workspace Diagnostics',
-- --         },
-- --         i = { '<cmd>LspInfo<cr>', 'Info' },
-- --         I = { '<cmd>LspInstallInfo<cr>', 'Installer Info' },
-- --         j = {
-- --             function()
-- --                 vim.lsp.diagnostic.goto_next()
-- --             end,
-- --             'Next Diagnostic',
-- --         },
-- --         k = {
-- --             function()
-- --                 vim.lsp.diagnostic.goto_prev()
-- --             end,
-- --             'Prev Diagnostic',
-- --         },
-- --         l = {
-- --             function()
-- --                 vim.lsp.codelens.run()
-- --             end,
-- --             'CodeLens Action',
-- --         },
-- --         m = { '<cmd>TSJToggle<CR>', 'Join/Split' },
-- --         o = { '<cmd>SymbolsOutline<CR>', 'Symbols Outline' },
-- --         q = {
-- --             function()
-- --                 vim.diagnostic.setloclist({ open = false })
-- --             end,
-- --             'Quickfix',
-- --         },
-- --         s = { '<cmd>Telescope lsp_document_symbols<cr>', 'Document Symbols' },
-- --         S = {
-- --             '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>',
-- --             'Workspace Symbols',
-- --         },
-- --     },
-- --     L = { '<cmd>Lazy<cr>', 'Lazy' },
-- --     m = { '<cmd>Mason<cr>', 'Mason' },
-- --     n = {
-- --         '<cmd>ene <BAR> startinsert <CR>',
-- --         'new file',
-- --     },
-- --     o = {
-- --         function()
-- --             vim.ui.open(vim.fn.expand('%'))
-- --         end,
-- --         'vim.open file',
-- --     },
-- --     q = {
-- --         name = 'Quickfix',
-- --         l = { '<cmd>lopen<cr>', 'Open Location List' },
-- --         q = { '<cmd>copen<cr>', 'Open Quickfix List' },
-- --     },
-- --     t = {
-- --         name = 'Terminal',
-- --         f = { '<cmd>ToggleTerm direction=float<cr>', 'Term Float' },
-- --         h = { '<cmd>ToggleTerm size=10 direction=horizontal<cr>', 'Term Horizontal' },
-- --         -- p = { _PYTHON_TOGGLE(), "Python" },
-- --         t = { '<cmd>ToggleTerm direction=tab<cr>', 'Term Tab' },
-- --         v = { '<cmd>ToggleTerm size=80 direction=vertical<cr>', 'Term Vertical' },
-- --     },
-- --     u = {
-- --         '<cmd>Telescope undo<CR>',
-- --         'Undo',
-- --     },
-- --     --   t = {
-- --     --     name = "toggle",
-- --     --     f = {
-- --     --       require("config.plugins.lsp.formatting").toggle,
-- --     --       "Format on Save",
-- --     --     },
-- --     --     s = {
-- --     --       function()
-- --     --         util.toggle("spell")
-- --     --       end,
-- --     --       "Spelling",
-- --     --     },
-- --     --     w = {
-- --     --       function()
-- --     --         util.toggle("wrap")
-- --     --       end,
-- --     --       "Word Wrap",
-- --     --     },
-- --     --     n = {
-- --     --       function()
-- --     --         util.toggle("relativenumber", true)
-- --     --         util.toggle("number")
-- --     --       end,
-- --     --       "Line Numbers",
-- --     --     },
-- --     --   },
-- --     --   ["<tab>"] = {
-- --     --     name = "tabs",
-- --     --     ["<tab>"] = { "<cmd>tabnew<CR>", "New Tab" },
-- --     --     n = { "<cmd>tabnext<CR>", "Next" },
-- --     --     d = { "<cmd>tabclose<CR>", "Close" },
-- --     --     p = { "<cmd>tabprevious<CR>", "Previous" },
-- --     --     ["]"] = { "<cmd>tabnext<CR>", "Next" },
-- --     --     ["["] = { "<cmd>tabprevious<CR>", "Previous" },
-- --     --     f = { "<cmd>tabfirst<CR>", "First" },
-- --     --     l = { "<cmd>tablast<CR>", "Last" },
-- --     --   },
-- -- }
-- --
-- -- wk.register(leader, { prefix = '<leader>' })
-- --
-- -- wk.register({ g = { name = '+goto' } })
