#!/bin/bash

DEST=/home/pi/bin/comics-downloader
SRC=/home/pi/Trabajo/comics-downloader

go build -o comics-downloader $SRC/cmd/downloader

cp download_comics.sh $DEST
cp comics_urls.txt $DEST
cp comics-downloader $DEST
