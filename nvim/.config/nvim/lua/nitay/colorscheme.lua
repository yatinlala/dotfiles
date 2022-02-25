vim.cmd [[
    highlight Normal guibg=none
    set background=dark
]]

local colorscheme = "gruvbox8_soft"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

require 'colorizer'.setup()
