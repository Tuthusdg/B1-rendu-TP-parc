#!/bin/bash
HORAIRE=$(date +%H%M%S)
DATE=$(date +'%y%m%d')

cd /srv
tar -czf /mnt/music_backup/music_"$DATE"_"$HORAIRE".tar.gz music/ 2>/dev/null
echo "le ficher à été sauvegardé"