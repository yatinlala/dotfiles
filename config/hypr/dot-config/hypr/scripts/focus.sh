#!/usr/bin/dash

group=$(hyprctl activewindow | grep -E "grouped: [^0$]")

activewindow_j=$(hyprctl activewindow -j)
group_j=$(echo "$activewindow_j" | jq ".grouped")

if [ "$group_j" = "[]" ]; then
  hyprctl dispatch movefocus "$1"
else
  window_id=$(echo "$activewindow_j" | jq -r ".address" | sed "s/^..//")
  workspace=$(hyprctl activeworkspace -j | jq '.id')
  only_group=$(hyprctl clients -j | jq --argjson workspace "$workspace" '[.[] | select(.workspace.id == $workspace and .hidden == false)] | length')
  if [ "$1" = "r" ]; then
    if [ "$only_group" = "1" ]; then
      hyprctl dispatch changegroupactive f
    else
      echo "$group" | grep -q "$window_id$" && hyprctl dispatch movefocus r || hyprctl dispatch changegroupactive f
    fi
  elif [ "$1" = "l" ]; then
    if [ "$only_group" = "1" ]; then
      hyprctl dispatch changegroupactive b
    else
      echo "$group" | grep -q ": $window_id" && hyprctl dispatch movefocus l || hyprctl dispatch changegroupactive b
    fi
  else
    hyprctl dispatch movefocus "$1"
  fi
fi
