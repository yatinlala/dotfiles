local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'GruvboxDark'
config.font = wezterm.font 'Ligalex  Mono'
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.window_close_confirmation = 'NeverPrompt'
config.warn_about_missing_glyphs=false

config.window_padding = {
  left = 1,
  right = 0,
  top = 1,
  bottom = 0,
}

return config
