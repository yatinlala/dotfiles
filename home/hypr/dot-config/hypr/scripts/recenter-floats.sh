#!/usr/bin/env bash

set -euo pipefail

# Hard-code multiple special workspaces here
WORKSPACES=(
        "special:signal"
        "special:ferdium"
        "special:spotify"
        # "special:float"
)

sleep 0.2

# Use focused monitor geometry (same behavior as the original script)
read -r MON_W MON_H <<<"$(
        hyprctl monitors -j |
                jq -r '.[] | select(.focused) | "\(.width) \(.height)"'
)"

# Gather all floating windows in any of the listed workspaces, then center them.
hyprctl clients -j | jq -r --argjson wss "$(printf '%s\n' "${WORKSPACES[@]}" | jq -R . | jq -s .)" '
  .[] |
  select(.floating == true) |
  select(.workspace.name as $ws | $wss | index($ws)) |
  "\(.address) \(.size[0]) \(.size[1])"
' | while read -r addr w h; do
        x=$(((MON_W - w) / 2))
        y=$(((MON_H - h) / 2))
        hyprctl dispatch movewindowpixel exact "$x" "$y,address:$addr" >/dev/null
done
