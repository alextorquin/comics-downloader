#!/bin/bash

sudo umount /mnt/Alex
sudo umount /mnt/comic

/home/pi/bin/utils/pushbullet.sh "DESMONTADOS 'Alex' y 'comic'"

pkill -f "YACReaderLibraryServer start"

/home/pi/bin/utils/pushbullet.sh "YACReaderLibraryServer APAGADA"
