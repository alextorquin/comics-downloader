#!/bin/bash

URL=($(cat "/Volumes/Expansion/Nubes/Google Drive/comics-downloader_urls.txt" | tr -s "\n" ","))
#URL=($(cat "/Users/alex/Downloads/comics/comics-downloader_urls.txt" | tr -s "\n" ","))

/Users/Alex/src/comics-downloader/comics-downloader -format=cbr -url=$URL -output=/Volumes/Filmoteca/Comictor
#/Users/Alex/src/comics-downloader/comics-downloader -format=cbr -url=$URL -output=/Users/alex/Downloads/comics