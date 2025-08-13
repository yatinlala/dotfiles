if status is-interactive
    abbr --position anywhere --add ytl xdg-launch yt-dlp -f '"bv*[height<=720]+ba"' --embed-chapters --embed-metadata --embed-subs --sub-langs '"en.*"'
    abbr --add e nvim
    abbr --add wmc nvim ~/.config/hypr/hyprland.conf

    abbr --add ls eza --icons
    abbr --add ll eza --icons -l
    abbr --add la eza --icons -la

    abbr --add mmute "echo 0 | sudo tee /sys/class/leds/platform::micmute/brightness"
end
