#!/bin/bash
PATH_LOG=$(find /var/log/yt/ -name "download.log" 2> /dev/null)
DATE=$(date "+%D %T")
URLs_FILE="/opt/yt/URL_vids_download.txt"

if [[ -z "$PATH_LOG" ]] ; then
    echo "The video cannot be downloaded because there isn't any log file"
fi


while read super_line; do

    titre=$(yt-dlp --get-title "$super_line")

    mkdir /opt/yt/downloads/"$titre"

    yt-dlp -o "/opt/yt/downloads/$titre/$titre.%(ext)s" "$super_line" >/dev/null
    yt-dlp --get-description "$super_line" > /opt/yt/downloads/"$titre"/description

    PATH_FILE=$(find / -name "$titre" 2> /dev/null)

    echo "File path : $PATH_FILE"
    echo "$DATE Video $super_line was downloaded. File path: $PATH_FILE" >> /var/log/yt/download.log
done   <<< "$(cat $URLs_FILE)"


echo "" > "$URLs_FILE"
