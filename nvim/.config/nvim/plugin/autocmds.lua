-- [[ Autocommands ]]
--  See `:help lua-guide-autocommands`
--
local function augroup(name)
    return vim.api.nvim_create_augroup('custom_' .. name, { clear = true })
end

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight on yanking',
    group = augroup('highlight_yank'),
    callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 300 })
    end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Update Protein Totals',
    group = augroup('update_totals'),
    pattern = vim.fn.expand('~') .. '/documents/org/diary/*.org',
    callback = function()
        require('custom.util').update_protein_totals()
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    desc = ':set formatoptions-=cro',
    group = augroup('format_options'),
    callback = function()
        vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
    end,
})

-- -- -- TODO maybe move each autocmd into a function and comment out in setup
-- -- local M = {}

-- --
-- -- function M.setup()
-- --     -- vim.cmd [[
-- --     --     augroup remember_folds
-- --     --         autocmd!
-- --     --         au BufWinLeave ?* mkview 1
-- --     --         au BufWinEnter ?* silent! loadview 1
-- --     --     augroup END]]
-- --
-- --
-- --     -- lastplace replacement. TODO test with folds to see if this is sufficient
-- --     -- vim.cmd([[
-- --     --   au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
-- --     -- ]])
-- --
-- --     -- resize splits if window got resized
-- --     vim.api.nvim_create_autocmd({ 'VimResized' }, {
-- --         group = augroup('resize_splits'),
-- --         callback = function()
-- --             local current_tab = vim.fn.tabpagenr()
-- --             vim.cmd('tabdo wincmd =')
-- --             vim.cmd('tabnext ' .. current_tab)
-- --         end,
-- --     })
-- --
-- --     -- -- go to last loc when opening a buffer
-- --     -- vim.api.nvim_create_autocmd("BufReadPost", {
-- --     --     group = augroup("last_loc"),
-- --     --     callback = function(event)
-- --     --         local exclude = { "gitcommit" }
-- --     --         local buf = event.buf
-- --     --         if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
-- --     --             return
-- --     --         end
-- --     --         vim.b[buf].lazyvim_last_loc = true
-- --     --         local mark = vim.api.nvim_buf_get_mark(buf, '"')
-- --     --         local lcount = vim.api.nvim_buf_line_count(buf)
-- --     --         if mark[1] > 0 and mark[1] <= lcount then
-- --     --             pcall(vim.api.nvim_win_set_cursor, 0, mark)
-- --     --         end
-- --     --     end,
-- --     -- })
-- --
-- --     -- -- set colorscheme
-- --     -- vim.api.nvim_create_autocmd("ColorScheme", {
-- --     -- 	callback = function()
-- --     -- 		if vim.o.background == "dark" then
-- --     -- 			vim.cmd([[
-- --     --                hi def IlluminatedWordText guibg=#504945
-- --     --                hi def IlluminatedWordRead guibg=#504945
-- --     --                hi def IlluminatedWordWrite guibg=#504945
-- --     --            ]])
-- --     -- 		else
-- --     -- 			vim.cmd([[
-- --     --                hi def IlluminatedWordText guibg=#ebdbb2
-- --     --                hi def IlluminatedWordRead guibg=#ebdbb2
-- --     --                hi def IlluminatedWordWrite guibg=#ebdbb2
-- --     --            ]])
-- --     -- 		end
-- --     -- 	end,
-- --     -- 	group = main_group,
-- --     -- })
-- --
-- --     vim.api.nvim_create_autocmd('TextYankPost', {
-- --         callback = function()
-- --             vim.highlight.on_yank({ timeout = 200 })
-- --         end,
-- --         group = augroup('highlight_yank'),
-- --     })
-- --
-- --     -- -- close some filetypes with <q>
-- --     -- vim.api.nvim_create_autocmd("FileType", {
-- --     --     group = augroup("close_with_q"),
-- --     --     pattern = {
-- --     --         "PlenaryTestPopup",
-- --     --         "help",
-- --     --         "lspinfo",
-- --     --         "man",
-- --     --         "notify",
-- --     --         "qf",
-- --     --         "query",
-- --     --         "spectre_panel",
-- --     --         "startuptime",
-- --     --         "tsplayground",
-- --     --         "neotest-output",
-- --     --         "checkhealth",
-- --     --         "neotest-summary",
-- --     --         "neotest-output-panel",
-- --     --     },
-- --     --     callback = function(event)
-- --     --         vim.bo[event.buf].buflisted = false
-- --     --         vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
-- --     --     end,
-- --     -- })
-- --     --
-- --     -- -- wrap and check for spell in text filetypes
-- --     -- vim.api.nvim_create_autocmd("FileType", {
-- --     --     group = augroup("wrap_spell"),
-- --     --     pattern = { "gitcommit", "markdown" },
-- --     --     callback = function()
-- --     --         vim.opt_local.wrap = true
-- --     --         vim.opt_local.spell = true
-- --     --     end,
-- --     -- })
-- --     --
-- --     -- -- Auto create dir when saving a file, in case some intermediate directory does not exist
-- --     -- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
-- --     --     group = augroup("auto_create_dir"),
-- --     --     callback = function(event)
-- --     --         if event.match:match("^%w%w+://") then
-- --     --             return
-- --     --         end
-- --     --         local file = vim.loop.fs_realpath(event.match) or event.match
-- --     --         vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
-- --     --     end,
-- --     -- })
-- -- end
-- --
-- -- function M.lsp_hov_highlight()
-- --     -- Document highlight
-- --     vim.api.nvim_command([[ hi LspReferenceText guibg=#504945]])
-- --     vim.api.nvim_create_autocmd('CursorHold', {
-- --         callback = function()
-- --             vim.lsp.buf.document_highlight()
-- --         end,
-- --         buffer = 0,
-- --         group = augroup('lsp_doc_highlight'),
-- --     })
-- --     vim.api.nvim_create_autocmd('CursorHoldI', {
-- --         callback = function()
-- --             vim.lsp.buf.document_highlight()
-- --         end,
-- --         buffer = 0,
-- --         group = augroup('lsp_cursor_highlight'),
-- --     })
-- --     vim.api.nvim_create_autocmd('CursorMoved', {
-- --         callback = function()
-- --             vim.lsp.buf.clear_references()
-- --         end,
-- --         buffer = 0,
-- --         group = augroup('lsp_clear_highlight'),
-- --     })
-- -- end
-- --
-- -- -- Automatically open diagnostics
-- -- function M.lsp_hov_diagnostics()
-- --     vim.api.nvim_create_autocmd('CursorHold', {
-- --         callback = function()
-- --             vim.diagnostic.open_float()
-- --         end,
-- --         buffer = 0,
-- --         group = augroup('lsp_open_diagnostic'),
-- --     })
-- --     -- vim.api.nvim_create_autocmd("CursorHoldI", {
-- --     -- 	callback = function()
-- --     -- 		vim.lsp.buf.signature_help()
-- --     -- 	end,
-- --     -- 	buffer = 0,
-- --     -- 	group = "main_group",
-- --     -- })
-- -- end
-- --
-- -- return M
