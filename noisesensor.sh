#!/bin/bash
#
# Noise activated recorder script

THRESHOLD=0.040000
NOTI_SERVICE=/home/pi/download/weaved_software/scripts/send_notification.sh
MAKER_SERVICE=/home/pi/python_example/maker_request.py
NOISE_LOG_HOME=/home/pi/audiotest

noise_compare() {
    awk -v NOISE=$1 -v THRESHOLD=$2 'BEGIN {if (NOISE > THRESHOLD) exit 0; exit 1}'
}

while true; do
    NOISE=$(sox -t alsa plughw:1 -n stat trim 0 00:00:01 2>&1 > /dev/null | grep 'Maximum amplitude' | cut -d ':' -f 2 | tr -d ' ')
    if noise_compare $NOISE $THRESHOLD; then
        #$NOTI_SERVICE 1 "Raspi Noise detected ($NOISE)" 'Ok' &
        $MAKER_SERVICE -e "noise_detected" -p "{\"value1\": $NOISE}"
        echo "Noise detected ($NOISE) - Recording..."
        sox -t alsa plughw:1 -t wav - trim 0 00:05:00 2> /dev/null | lame - $NOISE_LOG_HOME/$(date +%Y%m%d-%H%M%S).mp3
    fi
done
