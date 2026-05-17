-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "30")
hl.env("HYPRCURSOR_THEME", "BreezeX-Light-hyprcursor")
hl.env("HYPRCURSOR_SIZE", "30")
-- env = XCURSOR_SIZE,24
-- env = XCURSOR_THEME,Breeze Snow

-- env = QT_QPA_PLATFORM,wayland;xcb
-- env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("WLR_BACKEND", "vulkan")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct") --control wayland theme with Kvantum
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
