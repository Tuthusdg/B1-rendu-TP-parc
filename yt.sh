#!/bin/bash
PATH_LOG=$(find /var/log/yt/ -name "download.log" 2> /dev/null)
DATE=$(date "+%D %T")
if [ -z "$1" ]
then 
    echo "you didn't gave the URL"
elif [ -z "$2" ] 
then
    echo "Something is missing"
else
    if [ -z "$PATH_LOG" ] 
    then
        echo "The video cannot be downloaded because there isn't any log file"
    else
    mkdir /opt/yt/downloads/"$2"
    yt-dlp -o "/opt/yt/downloads/"$2"/$2.%(ext)s" "$1" >/dev/null
    yt-dlp --get-description "$1" > /opt/yt/downloads/"$2"/description
    echo "video $1 was downloaded"
    PATH_FILE=$(find / -name "$2" 2> /dev/null)
    echo "File path : $PATH_FILE"
    echo "$DATE Video $1 was downloaded. File path: $PATH_FILE" >> /var/log/yt/download.log
    fi
fi

