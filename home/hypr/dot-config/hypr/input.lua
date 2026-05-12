---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		repeat_delay = 350,
		repeat_rate = 38,

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
			tap_to_click = false,
		},

		focus_on_close = true, -- fixes swallow focus change
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

hl.device({
	name = "logitech-m325",
	sensitivity = -0.5,
})

hl.device({
	name = "elan0676:00-04f3:3195-touchpad",
	-- sensitivity = .2
})

hl.device({
	name = "lenovo-optical-mouse",
	sensitivity = 0.1,
})

hl.device({
	name = "logitech-g203-prodigy-gaming-mouse",
	sensitivity = -0.8,
})

hl.device({
	name = "ydotoold-virtual-device",
	kb_layout = "us",
	-- kb_variant =
	-- kb_options =
})
