#!/bin/bash

# obtener directorio de este script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

$DIR/../utils/pushbullet.sh "Descarga de comics iniciada."

$DIR/download_comics.sh ongoing.txt

$DIR/../utils/pushbullet.sh "Descarga de comics finalizada."