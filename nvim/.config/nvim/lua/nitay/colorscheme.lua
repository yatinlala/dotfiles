vim.cmd [[
highlight Normal guibg=none

let s:enabled = 0

function! ToggleBg()
    if s:enabled
        set bg=dark
        let s:enabled = 0
    else
        set bg=light
        let s:enabled = 1
    endif
endfunction

map <Leader><Leader>c :call ToggleBg()<CR>

set background=dark
]]

  
local colorscheme = "gruvbox8_soft"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
