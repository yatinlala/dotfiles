-- if true then
--     return
-- end
vim.pack.add({ "https://github.com/sainnhe/gruvbox-material" })

-- vim.g.gruvbox_material_transparent_background = 0
-- vim.g.gruvbox_material_foreground = "material"
vim.g.gruvbox_material_background = "hard" -- soft, medium, hard
-- vim.g.gruvbox_material_ui_contrast = "high" -- The contrast of line numbers, indent lines, etc.
-- vim.g.gruvbox_material_statusline_style = "mix"
-- vim.g.gruvbox_material_cursor = "auto"

-- vim.g.gruvbox_material_float_style = "none" -- Background of floating windows
--
vim.cmd([[
    let g:gruvbox_material_colors_override = {'fg0': ['#C3BDAA', '234'] }
]])

-- vim.cmd([[
--     "let g:gruvbox_material_colors_override = { 'bg_statusline1': ['#81a2be', '234'], 'bg0': ['#ffffff', '0'], }
--
--     let g:gruvbox_material_colors_override = {'bg_statusline1': ['#81a2be', '234'], 'bg2': ['#282828', '235']}
--     ]])
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_dim_inactive_windows = 1

-- function M.setColors()
--     vim.cmd('colorscheme gruvbox')
--     vim.cmd([[
--         hi def IlluminatedWordText guibg=#504945
--         hi def IlluminatedWordRead guibg=#504945
--         hi def IlluminatedWordWrite guibg=#504945
--         hi MatchWord cterm=underline gui=underline
--     ]])
-- end

vim.cmd.colorscheme("gruvbox-material")

-- vim.cmd("hi Pmenu guibg=#282828")
-- -- vim.cmd("hi NormalFloat guibg=#282828")
-- vim.cmd("hi! link FloatBorder Normal")
-- vim.cmd("hi IncSearch guibg=#458588") -- normal colors hard to distinguish
-- -- vim.cmd("hi! link NormalFloat Normal")

vim.cmd("hi StatusLine guifg=#c3bdaa")

local function apply_highlight_overrides()
    -- Let syntax highlighting determine colors without LSP semantic overlays.
    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
        vim.api.nvim_set_hl(0, group, {})
    end

    -- Keep keyword operators such as sizeof neutral.
    vim.api.nvim_set_hl(0, "@keyword.operator", { link = "Normal" })

    -- Keep function calls such as malloc neutral; definitions stay highlighted.
    vim.api.nvim_set_hl(0, "@function.call", { link = "Normal" })
    vim.api.nvim_set_hl(0, "@operator", { link = "Normal" })
    vim.api.nvim_set_hl(0, "@variable.member", { link = "Normal" })
    vim.api.nvim_set_hl(0, "@keyword.repeat", { link = "Normal" })
    vim.api.nvim_set_hl(0, "@keyword.conditional", { link = "Normal" })
    vim.api.nvim_set_hl(0, "@type.builtin", { link = "Normal" })

    -- Slightly dim delimiters such as semicolons, commas, colons, and dots.
    vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = "#96938a" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("DisableLspHighlights", { clear = true }),
    callback = apply_highlight_overrides,
})

apply_highlight_overrides()
