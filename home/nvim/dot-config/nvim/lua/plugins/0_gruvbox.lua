local packadd = require("plugins").pack_add

packadd({ "https://github.com/sainnhe/gruvbox-material" })

vim.g.gruvbox_material_transparent_background = 0
vim.g.gruvbox_material_foreground = "material"
vim.g.gruvbox_material_background = "hard" -- soft, medium, hard
vim.g.gruvbox_material_ui_contrast = "high" -- The contrast of line numbers, indent lines, etc.
vim.g.gruvbox_material_float_style = "bright" -- Background of floating windows
vim.g.gruvbox_material_statusline_style = "mix"
vim.g.gruvbox_material_cursor = "auto"

-- vim.cmd([[
--     "let g:gruvbox_material_colors_override = { 'bg_statusline1': ['#81a2be', '234'], 'bg0': ['#ffffff', '0'], }
--
--     let g:gruvbox_material_colors_override = {'bg_statusline1': ['#81a2be', '234'], 'bg2': ['#282828', '235']}
--     ]])
vim.g.gruvbox_material_better_performance = 1

vim.cmd.colorscheme("gruvbox-material")

-- vim.cmd("hi NormalFloat guibg=#282828")
vim.cmd("hi! link FloatBorder Normal")
vim.cmd("hi IncSearch guibg=#458588") -- normal colors hard to distinguish
-- vim.cmd("hi! link NormalFloat Normal")

-- vim.cmd('hi StatusLine guibg=#83a598 guifg=#fbf1c7')

-- function M.setColors()
--     vim.cmd('colorscheme gruvbox')
--     vim.cmd([[
--         hi def IlluminatedWordText guibg=#504945
--         hi def IlluminatedWordRead guibg=#504945
--         hi def IlluminatedWordWrite guibg=#504945
--         hi MatchWord cterm=underline gui=underline
--     ]])
-- end
