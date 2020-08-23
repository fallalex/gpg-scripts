#!/usr/bin/env bash
#
# gpg_remove.sh /dev/disk4

MYDEV=$1

if [ "$#" -ne 1 ]; then
    echo "You must provide the /dev/diskN for the RAMDISK"
    exit 1
fi

if diskutil list | grep -q "$MYDEV"; then
    echo "$MYDEV exists"
else
    echo "$MYDEV does not exist"
    exit 1
fi

if diskutil info $MYDEV | grep -q "RAMDISK"; then
    echo "$MYDEV is named RAMDISK, proceeding"
else
    echo "$MYDEV is not a RAMDISK"
    exit 1
fi

diskutil unmountDisk force $MYDEV
sudo dd if=/dev/zero of=$MYDEV
sudo dd if=/dev/urandom of=$MYDEV
diskutil eject $MYDEV

