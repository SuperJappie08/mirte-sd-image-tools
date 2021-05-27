#!/bin/bash

# Mount image and resize filesystem
loopvar=`losetup -fP --show /zoef_sd.img`
mount `ls $loopvar* | tail -n1` /mnt/image/

# Mount other folders
cp /usr/bin/qemu-arm-static /mnt/image/usr/bin/
mount --bind /dev /mnt/image/dev/
mount --bind /sys /mnt/image/sys/
mount --bind /proc /mnt/image/proc/
mount --bind /dev/pts /mnt/image/dev/pts
