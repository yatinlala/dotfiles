local utils = require("mp.utils")

function show_comments()
	local video_path = mp.get_property("path")

	if not video_path then
		mp.osd_message("No video loaded")
		return
	end

	mp.osd_message("Loading comments...")

	-- Path to the bash script
	local script_path = os.getenv("HOME") .. "/.config/mpv/util/show_comments.sh"

	-- Run the script completely detached from MPV
	local cmd = {
		name = "subprocess",
		playback_only = false,
		detach = true,
		args = { "sh", "-c", script_path .. ' "' .. video_path .. '" >/dev/null 2>&1 &' },
	}

	mp.command_native(cmd)
end

mp.add_key_binding("n", "show-youtube-comments", show_comments)

-- mp.osd_message("YouTube comments script loaded (Ctrl+c to view)")
