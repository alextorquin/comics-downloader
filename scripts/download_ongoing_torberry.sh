#!/bin/bash

# obtener directorio de este script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

$DIR/download_comics.sh ongoing.txt
