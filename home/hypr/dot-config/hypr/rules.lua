-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

hl.window_rule({
	match = { title = "MPV: YouTube Comments" },
	float = true,
	size = "monitor_w*.6 monitor_h*.7",
	center = true,
})
hl.window_rule({
	match = { class = "blueman-manager|org.pulseaudio.pavucontrol" },

	float = true,
	size = "monitor_w*.6 monitor_h*.7",
	center = true,
	opacity = 0.95,
})
hl.window_rule({
	match = { class = "xdg-desktop-portal-gtk" },

	float = true,
	size = "monitor_w*.5 monitor_h*.7",
	center = true,
	opacity = 0.95,
})
hl.window_rule({
	match = { class = "gtk-pipe-viewer" },

	opacity = 0.95,
	workspace = 10,
})
-- windowrule {
--     name = fzfpopup
--     match:class = (org.yatin.fzfpopup)
--
--     opacity = .95 .95
--     float = true
--     center = true
--     size = (monitor_w*.8) (monitor_h*.8)
-- }

-- # windowrule {
-- #     name = nixpkgs-float
-- #     initialTitle = "https://search.nixos.org/packages?channel=unstable&include_home_manager_options=1&include_modular_service_options=1&include_nixos_options=1 - qutebrowser"
-- #
-- #     workspace = special:nixpkgs-float
-- #     float = true
-- #     size = (monitor_w*.9) (monitor_h*.85)
-- #     center = true
-- # }

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)
