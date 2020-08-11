#!/bin/bash

if [[ $OSTYPE == *"darwin"* ]] 
then
 DEST=/Users/alex/bin
else
 DEST=/home/pi/bin
fi

# obtener directorio de este script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $DIR
echo "Actualizando código fuente..."
git pull

rm -rf target/*

go build -o $DIR/target/comics-downloader/comics-downloader $DIR/cmd/downloader

cp scripts/* target/comics-downloader/
cp -rf target/comics-downloader $DEST

ln -s $DEST/comics-downloader/download_comics.sh /usr/bin/download_comics

