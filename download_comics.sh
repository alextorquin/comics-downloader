#!/bin/zsh

URL=($(cat comics_urls.txt | tr -s "\n" ","))

comics-downloader -format=cbr -url=$URL -output=/Volumes/Almacen/Prueba
