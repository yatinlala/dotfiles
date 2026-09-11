-- n opens comments; Shift+n opens the description.
local function show_popup(kind)
    local path = mp.get_property("path")
    if not path then
        mp.osd_message("No video loaded")
        return
    end

    local title = kind == "comments" and "Comments" or "Description"
    local script = mp.command_native({"expand-path", "~~/util/show_" .. kind .. ".sh"})
    local result = mp.command_native({
        name = "subprocess",
        playback_only = false,
        detach = true,
        args = {"kitty", "--title=MPV: YouTube " .. title, "bash", script, path},
    })
    if not result or result.status ~= 0 then
        mp.osd_message("Could not open " .. kind .. " window")
    end
end

mp.add_key_binding("n", "show-youtube-comments", function() show_popup("comments") end)
mp.add_key_binding("N", "show-youtube-description", function() show_popup("description") end)
