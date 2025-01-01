-- config.warn_about_missing_glyphs=false
--
-- config.window_padding = {
--   left = 1,
--   right = 0,
--   top = 1,
--   bottom = 0,
-- }
--
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "GruvboxDark"
-- config.color_scheme = "Gruvbox Dark (Gogh)"

config.font = wezterm.font("JetBrainsMono Nerd Font")

config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true

config.window_close_confirmation = "NeverPrompt"

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Bold" }),

	-- The size of the font in the tab bar.
	-- Default to 10.0 on Windows but 12.0 on other systems
	font_size = 12.0,

	-- -- The overall background color of the tab bar when
	-- -- the window is focused
	-- active_titlebar_bg = "#333333",
	--
	-- -- The overall background color of the tab bar when
	-- -- the window is not focused
	-- inactive_titlebar_bg = "#333333",
}

config.colors = {
	-- tab_bar = {
	-- 	-- The color of the inactive tab bar edge/divider
	-- 	inactive_tab_edge = "#575757",
	-- },
}

return config
