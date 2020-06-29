#!/bin/bash

URL_PATH="/Volumes/Expansion/Nubes/Google Drive/Swap/Comic_Downloader_URL_Files/"
DEST="/Volumes/Filmoteca/Comictor"

# obtener directorio de este script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

URL=($(cat "$URL_PATH/complete_series.txt" | tr -s "\n" ","))

$DIR/comics-downloader -format=cbr -url=$URL -output=$DEST > $DIR/comics-downloader.out