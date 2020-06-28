#!/bin/zsh

DEST=/Users/alex/bin
SRC=/Users/alex/src/comics-downloader

go build -o comics-downloader $SRC/cmd/downloader

rm $DEST/download_comics.sh
ln -s $SRC/download_comics.sh $DEST/download_comics.sh