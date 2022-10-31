local M = {}

function M.setup()
    -- vim.cmd [[
    --     augroup remember_folds
    --         autocmd!
    --         au BufWinLeave ?* mkview 1
    --         au BufWinEnter ?* silent! loadview 1
    --     augroup END]]

    vim.api.nvim_create_autocmd("BufEnter", { callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
    end })
    vim.api.nvim_create_autocmd("ColorScheme", { callback = function()
        vim.cmd [[
         hi def IlluminatedWordText guibg=#504945
         hi def IlluminatedWordRead guibg=#504945
         hi def IlluminatedWordWrite guibg=#504945
         ]]
    end })
    vim.api.nvim_create_autocmd("TextYankPost", { callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end
    })
end

function M.lsp_hov_highlight()
    -- Document highlight
    vim.api.nvim_command [[ hi LspReferenceText guibg=#504945]]
    vim.api.nvim_create_autocmd("CursorHold", { callback = function() vim.lsp.buf.document_highlight() end, buffer = 0 })
    vim.api.nvim_create_autocmd("CursorHoldI", { callback = function() vim.lsp.buf.document_highlight() end, buffer = 0 })
    vim.api.nvim_create_autocmd("CursorMoved", { callback = function() vim.lsp.buf.clear_references() end, buffer = 0 })

    -- Automatically open diagnostics
    vim.cmd[[
     autocmd CursorHold * lua vim.diagnostic.open_float()
     autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help() ]]
end

function M.lsp_hov_diagnostics()
    -- Automatically open diagnostics
    vim.cmd[[
     autocmd CursorHold * lua vim.diagnostic.open_float()
     autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help() ]]
end

return M
