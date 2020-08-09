#!/bin/bash

DEST=/Users/alex/bin

# obtener directorio de este script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

rm -rf target/*

go build -o target/comics-downloader/comics-downloader $DIR/cmd/downloader

cp scripts/* target/comics-downloader/
cp -rf target/comics-downloader $DEST


if [[ $1 == *"tornas"* ]] 
then
 scp -r $DEST/comics-downloader pi@192.168.1.70:/home/pi/bin
fi

