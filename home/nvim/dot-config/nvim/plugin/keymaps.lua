-- [ Basic Keymaps ]
-- vim.keymap.set("n", "<leader>cd", '<cmd>lua vim.fn.chdir(vim.fn.expand("%:p:h"))<CR>', { desc = "cd to %'s dir" })

-- [ NORMAL ]
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- vim.keymap.set("n", "<M-h>", "<C-w><", { desc = "Resize" })
-- vim.keymap.set("n", "<M-l>", "<C-w>>", { desc = "Resize" })
-- vim.keymap.set("n", "<M-j>", "<C-w>-", { desc = "Resize" })
-- vim.keymap.set("n", "<M-k>", "<C-w>+", { desc = "Resize" })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

vim.keymap.set("n", "<S-h>", "<cmd>tabprev<CR>")
vim.keymap.set("n", "<S-l>", "<cmd>tabnext<CR>")

-- vim.keymap.set("n", "<M-H>", "<cmd>tabmove -1<CR>")
-- vim.keymap.set("n", "<M-L>", "<cmd>tabmove +1<CR>")

vim.keymap.set("n", "<leader>f", ":find ", { desc = "[F]ind file" })
vim.keymap.set("n", "<leader>G", ":copen | sil grep ", { desc = "Grep" })
vim.keymap.set("n", "<leader>h", ":help ", { desc = "Search [H]elp" })

-- vim.keymap.set("n", "gQ", "mzgggqG`z<cmd>delmarks z<cr>zz", { desc = "Format buffer" })

vim.keymap.set("n", "<C-n>", function()
    vim.opt.number = not vim.opt.number:get()
end, { desc = "Toggle number" })

vim.keymap.set("n", "<C-s>", function()
    if vim.opt.laststatus:get() == 0 then
        vim.opt.laststatus = 3
    else
        vim.opt.laststatus = 0
    end
end, { desc = "Toggle statusline" })

-- Navigate buffers
-- vim.keymap.set("n", "<leader>x", "<cmd>e #<CR>", { desc = "Alternate buffer" }) -- same as C-6 (^)
vim.keymap.set("n", "-w", "<cmd>b#<CR>", { desc = "Alternate buffer" })

-- [ /NORMAL ]

-- [ OP-PENDING ]

-- Select around buffer
vim.keymap.set({ "o", "x" }, "aB", function()
    vim.cmd("normal! gg0")
    vim.cmd("normal! V")
    vim.cmd("normal! G$")
end, { desc = "Select entire buffer" })

vim.keymap.set({ "o", "x" }, "iB", function()
    local start = 1
    local last = vim.fn.line("$")

    -- skip leading blank lines
    while start <= last and vim.fn.getline(start):match("^%s*$") do
        start = start + 1
    end

    -- skip trailing blank lines
    while last >= start and vim.fn.getline(last):match("^%s*$") do
        last = last - 1
    end

    -- make selection
    vim.cmd(string.format("normal! %dGV%dG", start, last))
end, { desc = "Select inner buffer" })

-- [ /OP-PENDING ]

-- [ TERMINAL ]

-- exit terminal mode
vim.keymap.set("t", "JK", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")

vim.keymap.set("n", "<leader>t", "<cmd>term<CR>", { desc = "Open terminal" })
vim.keymap.set("n", "<leader>T", "<cmd>tabnew | term<CR>", { desc = "Open terminal in new tab" })
vim.keymap.set("n", "<leader>e", "<cmd>term lf %:h<CR>i", { desc = "Open Lf" })

-- vim.keymap.set("n", "<leader>st", function()
--     vim.cmd.vnew()
--     vim.cmd.term()
--     vim.cmd.wincmd("J")
--     vim.api.nvim_win_set_height(0, 15)
--     vim.cmd.startinsert()
-- end, { desc = "Open Lf" })

-- [ /TERMINAL ]

-- Source things
-- vim.keymap.set("n", "<leader>X", "<cmd>source %<CR>", { desc = "Source file" })
-- vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Source line" })
-- vim.keymap.set("v", "<leader>x", "<cmd>lua<CR>", { desc = "Source selection" })

-- These are defaults in 0.11
-- vim.keymap.set('n', '[b', '<cmd>bprevious<CR>')
-- vim.keymap.set('n', ']b', '<cmd>bnext<CR>')

-- vim.keymap.set("n", "<leader>B", "<cmd>.!bc<CR>", { desc = "Filter to bc" })

-- vim.keymap.set('n', 'gd', '<C-]>', { silent = true, desc = 'Go to Definition' })

-- Visual --
-- local opts = { silent = true }
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
