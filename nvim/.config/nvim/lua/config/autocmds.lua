local M = {}

function M.setup()
	local main_group = vim.api.nvim_create_augroup("main_group", { clear = true })
	-- vim.cmd [[
	--     augroup remember_folds
	--         autocmd!
	--         au BufWinLeave ?* mkview 1
	--         au BufWinEnter ?* silent! loadview 1
	--     augroup END]]

	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function()
			vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
		end,
		group = main_group,
	})
	-- vim.api.nvim_create_autocmd("ColorScheme", {
	-- 	callback = function()
	-- 		if vim.o.background == "dark" then
	-- 			vim.cmd([[
	--                hi def IlluminatedWordText guibg=#504945
	--                hi def IlluminatedWordRead guibg=#504945
	--                hi def IlluminatedWordWrite guibg=#504945
	--            ]])
	-- 		else
	-- 			vim.cmd([[
	--                hi def IlluminatedWordText guibg=#ebdbb2
	--                hi def IlluminatedWordRead guibg=#ebdbb2
	--                hi def IlluminatedWordWrite guibg=#ebdbb2
	--            ]])
	-- 		end
	-- 	end,
	-- 	group = main_group,
	-- })
	vim.api.nvim_create_autocmd("TextYankPost", {
		callback = function()
			vim.highlight.on_yank({ timeout = 200 })
		end,
		group = main_group,
	})
end

function M.lsp_hov_highlight()
	-- Document highlight
	vim.api.nvim_command([[ hi LspReferenceText guibg=#504945]])
	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			vim.lsp.buf.document_highlight()
		end,
		buffer = 0,
		group = "main_group",
	})
	vim.api.nvim_create_autocmd("CursorHoldI", {
		callback = function()
			vim.lsp.buf.document_highlight()
		end,
		buffer = 0,
		group = "main_group",
	})
	vim.api.nvim_create_autocmd("CursorMoved", {
		callback = function()
			vim.lsp.buf.clear_references()
		end,
		buffer = 0,
		group = "main_group",
	})
end

-- Automatically open diagnostics
function M.lsp_hov_diagnostics()
	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			vim.diagnostic.open_float()
		end,
		buffer = 0,
		group = "main_group",
	})
	-- vim.api.nvim_create_autocmd("CursorHoldI", {
	-- 	callback = function()
	-- 		vim.lsp.buf.signature_help()
	-- 	end,
	-- 	buffer = 0,
	-- 	group = "main_group",
	-- })
end

return M
