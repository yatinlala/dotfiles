#!/usr/bin/env bash
##
##
## NOTE: I'd much prefer to do something like:
## for class in "${CLASSES[@]}"; do
#      hyprctl dispatch resizewindowpixel exact 90% 90%,class:$class
#      hyprctl dispatch centerwindow class:$class
# done
# but centerwindow only targets the activewindow, it doesn't let you
# target an arbitrary window. TODO probably there should be a PR for
# this, my solution in the meantime works but is probably more
# cumbersome than necessary.

set -euo pipefail

CLASSES=(signal ferdium spotify obsidian)

mons_json="$(hyprctl monitors -j)"
clients_json="$(hyprctl clients -j)"

# Emit: addr monitorId monX monY monW monH
jq -r --argjson mons "$mons_json" --argjson cls "$(printf '%s\n' "${CLASSES[@]}" | jq -R . | jq -s .)" '
  .[]
  | select(.class? != null)
  | select((.class | ascii_downcase) as $c | $cls | index($c))
  | .address as $addr
  | .monitor as $mid
  | ($mons[] | select(.id == $mid)) as $m
  | "\($addr) \($mid) \($m.x) \($m.y) \($m.width) \($m.height)"
' <<<"$clients_json" |
        while read -r addr mid mx my mw mh; do
                # 90% of monitor
                ww=$((mw * 90 / 100))
                wh=$((mh * 90 / 100))

                # centered top-left in global coords (monitor has an x/y offset)
                x=$((mx + (mw - ww) / 2))
                y=$((my + (mh - wh) / 2))

                # resize + move that specific window
                hyprctl dispatch resizewindowpixel exact "$ww" "$wh,address:$addr" >/dev/null
                hyprctl dispatch movewindowpixel exact "$x" "$y,address:$addr" >/dev/null
        done
