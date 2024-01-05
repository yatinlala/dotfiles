#!/usr/bin/env bash

type=$1
direction=$2

if [[ $type == "focus" ]]; then
        active_window=$(hyprctl activewindow | grep 'grouped: ' | awk '{print $2}')

        if [[ $active_window != "0" && ($direction == "r" || $direction = "l") ]]; then
                hyprctl dispatch changegroupactive $direction
        elif [[ $active_window != "0" && ($direction == "d" || $direction = "u") ]]; then
                hyprctl dispatch moveoutofgroup $direction
        else
                hyprctl dispatch movefocus $direction
        fi
elif [[ $type = "group" ]]; then
        echo 'hi'
        
fi
