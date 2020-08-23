#!/usr/bin/env bash
#
# gpg_create_tmp.sh /Volumes/BACKUP_2/gpg_backup.tar.gpg

GPG_BACKUP="$1"

if [ "$#" -ne 1 ]; then
    echo "You must provide the path for the .tar.gpg file"
    echo "For example: /Volumes/BACKUP_2/gpg_backup.tar.gpg"
    exit 1
fi

GPG_BACKUP_PARENT="$(dirname "$GPG_BACKUP")"
if [ ! -d "$GPG_BACKUP_PARENT" ]; then
    echo "$GPG_BACKUP_PARENT does not exist"
    exit 1
fi

# create and mount tmpfs
# make 50MB exfat ram disk from 512 bytes sectors
RAMDISKMB=50
let RAMDISKSECTORS=$RAMDISKMB*1000000/512
MYDEV=$(sudo hdiutil attach -nomount ram://$RAMDISKSECTORS)
sudo diskutil erasevolume HFS+ "RAMDISK" $MYDEV
sudo diskutil enableOwnership $MYDEV
#sudo diskutil unmountDisk $MYDEV
#MYMOUNT=$(mktemp -d "${TMPDIR:-/tmp/}ramdisk.XXXXXX")
#sudo diskutil mount -mountPoint $MYMOUNT
MYMOUNT=$(df | grep $MYDEV | grep -o '/Volumes/.*$')
sudo chown -R $USER:$(id -g) "$MYMOUNT"
sudo chmod -R 700 "$MYMOUNT"

# setup temporary .gnupg directory from backup
gpg --pinentry-mode loopback --decrypt $GPG_BACKUP | tar -C "$MYMOUNT" -xvf -

echo
echo $MYMOUNT
echo $MYDEV
