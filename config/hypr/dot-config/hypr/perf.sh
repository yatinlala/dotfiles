#!/usr/bin/env sh
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    hyprctl notify -1 1000 "rgb(e06c75)" "Animations off"
    exit
else
    hyprctl --batch "\
        keyword animations:enabled 1;\
        keyword decoration:blur:enabled 1;\
        keyword general:gaps_in 3;\
        keyword general:gaps_out 6;\
        keyword general:border_size 3;\
        keyword decoration:rounding 3"
    hyprctl notify -1 1000 "rgb(98c379)" "Animations on"
    exit
fi
# hyprctl notify -1 1000 "rgb(98c379)" "Animations on"
# hyprctl reload
