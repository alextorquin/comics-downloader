#!/bin/bash
echo $1
if [[ $OSTYPE == *"darwin"* ]] 
then
    URL_PATH="/Volumes/home/Drive/Comic_Downloader_URL_Files/"
    #DEST="/Volumes/comic/Comictor"
    DEST="/Users/Alex/Downloads"
else
    URL_PATH="/mnt/Alex/Drive/Comic_Downloader_URL_Files/"
    DEST="/mnt/comic/Comictor"
fi

# obtener directorio de este script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

URL=($(cat "$URL_PATH$1" | tr -s "\n" ","))

#/home/pi/bin/utils/pushbullet.sh "Descarga de cómics" "$($DIR/comics-downloader -format=cbr -url=$URL -output=$DEST)"

$DIR/comics-downloader -format=cbr -url=$URL -output=$DEST