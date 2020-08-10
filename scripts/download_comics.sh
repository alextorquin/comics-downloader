#!/bin/bash

# obtener directorio de este script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ $OSTYPE == *"darwin"* ]] 
then
    URL_PATH="/Volumes/home/Drive/Comic_Downloader_URL_Files/"
    DEST="/Users/Alex/Downloads"
else
    URL_PATH="/mnt/Alex/Drive/Comic_Downloader_URL_Files/"
    DEST="/mnt/comic/Comictor"
fi

_file="$URL_PATH$1"
[ $# -eq 0 ] && { echo "Usage: $0 filename"; exit 1; }
[ ! -f "$_file" ] && { $DIR/../utils/pushbullet.sh "Error: $0 file not found."; exit 2; }
 
if [ -s "$_file" ] 
then
    $DIR/../utils/pushbullet.sh "Descarga de comics iniciada."

    URL=($(cat "$_file" | tr -s "\n" ","))

    #/home/pi/bin/utils/pushbullet.sh "Descarga de cómics" "$($DIR/comics-downloader -format=cbr -url=$URL -output=$DEST)"

    $DIR/comics-downloader -format=cbr -url=$URL -output=$DEST

    if [[ -n "$2" && "$2" == "clear" ]]; then
        cat "$_file" >> "$URL_PATHhistorico.txt"
        cat /dev/null > "$_file"
    fi

    $DIR/../utils/pushbullet.sh "Descarga de comics finalizada."
else
    $DIR/../utils/pushbullet.sh "El fichero esta vacio" "$_file"
fi
