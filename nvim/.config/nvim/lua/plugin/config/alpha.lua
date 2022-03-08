local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
    return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
[[          &&& &&  & &&]],
[[      && &\/&\|& ()|/ @, &&]],
[[      &\/(/&/&||/& /_/)_&/_&]],
[[   &() &\/&|()|/&\/ '%" & ()]],
[[  &_\_&&_\ |& |&&/&__%_/_& &&]],
[[&&   && & &| &| /& & % ()& /&&]],
[[ ()&_---()&\&\|&&-&&--%---()~]],
[[     &&     \|||]],
[[             |||]],
[[             |||]],
[[             |||]],
[[       , -=-~  .-^- _]],
[[              `]],
}
dashboard.section.buttons.val = {
    dashboard.button("SPC f f", "  Find file", ":Telescope find_files <CR>"),
    dashboard.button("SPC n", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("SPC P", "  Find project", ":Telescope projects <CR>"),
    dashboard.button("SPC f r", "  Recently used files", ":Telescope oldfiles <CR>"),
    dashboard.button("SPC F", "  Find text", ":Telescope live_grep <CR>"),
    dashboard.button("SPC e n", "  Edit init.lua", ":e ~/.config/nvim/init.lua <CR>"),
    dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

dashboard.section.footer.val = ""

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)

