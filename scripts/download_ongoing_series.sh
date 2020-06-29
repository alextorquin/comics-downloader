#!/bin/bash

URL_PATH="/home/pi/gdrive_swap/Comic_Downloader_URL_Files/"
DEST="/home/pi/TorPort/Filmoteca/Comictor"

# obtener directorio de este script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

URL=($(cat "$URL_PATH/ongoing_series.txt" | tr -s "\n" ","))

#/home/pi/bin/utils/pushbullet.sh "Descarga de cómics" "$($DIR/comics-downloader -format=cbr -url=$URL -output=$DEST)"

$DIR/comics-downloader -format=cbr -url=$URL -output=$DEST