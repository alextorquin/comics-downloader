#!/bin/bash

sudo mount -t nfs 192.168.1.55:/volume1/homes/Alex /mnt/Alex
sudo mount -t nfs 192.168.1.55:/volume1/comic /mnt/comic

/home/pi/bin/utils/pushbullet.sh "MONTADOS 'Alex' y 'comic'"

nohup YACReaderLibraryServer start &

/home/pi/bin/utils/pushbullet.sh "YACReaderLibraryServer INICIADA"

