#!/bin/sh

CUR_TIME=$(date +%s)
STATUS=$(cat /var/tmp/202020_timer)

if [[ $STATUS == "PAUSED" ]]; then
	echo ""
elif [[ $STATUS > $CUR_TIME ]]; then
	DIFF=$(( (STATUS - CUR_TIME) ))
	echo $( date -d @$DIFF +%M:%S )
else
	CUR_BRIGHTNESS=$(light)
	date --date='20 minutes' +%s > /var/tmp/202020_timer
	notify-send -t 20000 "20 second eye break!" &
	# sleep 1 && light -S 0.01 &
	# sleep 20 && light -S $CUR_BRIGHTNESS &
fi
