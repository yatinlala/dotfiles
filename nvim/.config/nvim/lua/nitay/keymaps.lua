local opts = { noremap = true, silent = true }

-- Shorten function name
local map = vim.api.nvim_set_keymap

--Remap space as leader key
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Sensible split movement
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
map("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
map("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Centered searches
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)
-- Centered line cat
map('n', 'J', 'mzJ\'z', opts)


map('n', 'gf', ':e <cfile><CR>', opts)

-- -- Smart(ish) compilation
-- map('n', '<leader>c',  ':w! \\| !comp <c-r>%<CR><CR>', {})
-- -- Enable spell checking
-- map('n', '<leader><leader>s', ':setlocal spell! spelllang=en_us<CR>', {})
-- -- Search and replace
-- map('n', '<leader>s', ':%s//g<Left><Left>', {})
-- -- GF creates new file if needed
-- map('n', 'gf',  ':edit <cfile><cr>', {})

-- Insert --
-- Undo break points
map('i', ',', ',<c-g>u', opts)
map('i', '.', '.<c-g>u', opts)
map('i', '(', '(<c-g>u', opts)

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Don't override copy register when pasting into highlight
map("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv", opts)
map("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Command --
-- Force save a sudoer file
map('c', 'w!!', 'w !sudo tee %', {})

-- -- Fugitive
-- map('n', '<leader>gs',  ':G<CR>', {})
-- map('n', '<leader>gf',  ':diffget //3<CR>', {})
-- map('n', '<leader>gj',  ':diffget //2<CR>', {})
--
-- vim.cmd([[
--
-- augroup remember_folds
--   autocmd!
--   autocmd BufWinLeave *.vim mkview
--   autocmd BufWinEnter *.vim silent! loadview
-- augroup END
--
-- ]])
