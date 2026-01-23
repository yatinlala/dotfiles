local utils = require("mp.utils")

function show_description()
	local video_path = mp.get_property("path")

	if not video_path then
		mp.osd_message("No video loaded")
		return
	end

	mp.osd_message("Loading description...")

	-- Path to the bash script
	local script_path = os.getenv("HOME") .. "/.config/mpv/util/show_description.sh"

	-- Run the script completely detached from MPV
	local cmd = {
		name = "subprocess",
		playback_only = false,
		detach = true,
		args = { "sh", "-c", script_path .. ' "' .. video_path .. '" >/dev/null 2>&1 &' },
	}

	mp.command_native(cmd)
end

mp.add_key_binding("N", "show-youtube-description", show_description)
