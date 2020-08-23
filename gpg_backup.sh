#!/usr/bin/env bash
#
# gpg_backup.sh ~ /Volumes/BACKUP_2/gpg_bakup.tar.gpg

GPG_HOME_PARENT="$1"
BACKUP_LOCATION="$2"

if [ "$#" -ne 2 ]; then
    echo "You must provide a gpg homedir path"
    echo "such as ~ where the defualt '.gnupg' director is"
    echo "You must provide a path and name for the backup '.tar.gpg' file"
    echo "such as /Volumes/BACKUP_2/gpg_bakup.tar.gpg"
    exit 1
fi

if [ ! -d "$GPG_HOME_PARENT/.gnupg" ]; then
    echo "$GPG_BACKUP_PARENT/.gnupg does not exist"
    exit 1
fi

umask 077
tar -c --exclude "random_seed" --exclude "S.*" -C $GPG_HOME_PARENT .gnupg | gpg --pinentry-mode loopback --no-symkey-cache --symmetric -o $BACKUP_LOCATION
umask 022
