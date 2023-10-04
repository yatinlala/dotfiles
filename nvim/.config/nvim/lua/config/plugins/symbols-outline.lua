local M = {
    'simrat39/symbols-outline.nvim',
    cmd = 'SymbolsOutline',
}

function M.config()
    local opts = {
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = false,
        position = 'right',
        relative_width = true,
        width = 30,
        auto_close = false,
        show_numbers = false,
        show_relative_numbers = false,
        show_symbol_details = true,
        preview_bg_highlight = 'Pmenu',
        autofold_depth = nil,
        auto_unfold_hover = true,
        wrap = false,
        keymaps = { -- These keymaps can be a string or a table for multiple keys
            close = { '<Esc>', 'q' },
            goto_location = '<Cr>',
            focus_location = 'o',
            hover_symbol = '<C-space>',
            toggle_preview = 'K',
            rename_symbol = 'r',
            code_actions = 'a',
            fold = 'h',
            unfold = 'l',
            fold_all = 'W',
            unfold_all = 'E',
            fold_reset = 'R',
        },
    }

    require('symbols-outline').setup(opts)
end

return M
