#!/bin/zsh

DEST=pi@192.168.1.70:/home/pi/bin

# obtener directorio de este script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

rm -rf target/*

go build -o target/comics-downloader/comics-downloader $DIR/cmd/downloader

cp scripts/* target/comics-downloader/

scp -r target/comics-downloader $DEST
