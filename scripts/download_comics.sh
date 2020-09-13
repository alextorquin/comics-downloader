#!/bin/bash

# obtener directorio de este script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

[ $# -eq 0 ] && { echo "Usage: $1 filename"; exit 1; }

if [ ! -f /tmp/start_download_comics ] && [ $1 == "complete.txt" ]; then 
       exit 0;
fi

rm /tmp/start_download_comics

$DIR/start-library-server.sh

sleep 3

if [[ $OSTYPE == *"darwin"* ]] 
then
    URL_PATH="/Volumes/home/Drive/Comic_Downloader_URL_Files/"
    DEST="/Users/Alex/Downloads"
else
    URL_PATH="/mnt/Alex/Drive/Comic_Downloader_URL_Files/"
    DEST="/mnt/comic/Comictor"
fi

_file="$URL_PATH$1"
[ ! -f "$_file" ] && { $DIR/../utils/pushbullet.sh "Error: No existe el fichero $1 ."; $DIR/stop-library-server.sh; exit 2; }
 
if [ -s "$_file" ] 
then

    URL=($(cat "$_file" | tr -s "\n" ","))

    $DIR/../utils/pushbullet.sh "Descarga de comics $1 iniciada: $URL"

    #/home/pi/bin/utils/pushbullet.sh "Descarga de cómics" "$($DIR/comics-downloader -format=cbr -url=$URL -output=$DEST)"

    $DIR/comics-downloader -format=cbr -url=$URL -output=$DEST

    if [[ -n "$2" && "$2" == "clear" ]]; then
        cat "$_file" >> "$URL_PATH"historico.txt
        cat /dev/null > "$_file"
    fi

    $DIR/../utils/pushbullet.sh "Descarga de comics $1 finalizada. Actualizando libreria."

    YACReaderLibraryServer update-library $DEST

    $DIR/../utils/pushbullet.sh "Libreria actualizada."
else
    $DIR/../utils/pushbullet.sh "El fichero $1 esta vacio."
    $DIR/stop-library-server.sh
fi
