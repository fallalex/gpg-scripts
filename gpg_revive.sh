#!/usr/bin/env bash
#
# gpg_revive.sh /Volume/RAMDISK/.gnupg ~/.gnupg
# gpg_revive.sh /Volume/RAMDISK/.gnupg /Volume/RAMDISK\ 1/.gnupg

GPG_RAMDISK_LOCATION="$1"
GPG_LOCATION="$2"

gpg --pinentry-mode loopback --homedir "$GPG_RAMDISK_LOCATION" --export > "$GPG_RAMDISK_LOCATION/pub_keyring.gpg"
gpg --pinentry-mode loopback --homedir "$GPG_RAMDISK_LOCATION" --export-secret-keys > "$GPG_RAMDISK_LOCATION/sec_keyring.gpg"
gpg --homedir "$GPG_RAMDISK_LOCATION" --export-ownertrust > "$GPG_RAMDISK_LOCATION/gpg_trust.txt"

gpg --homedir "$GPG_LOCATION" --no-tty --batch --yes --import < "$GPG_RAMDISK_LOCATION/pub_keyring.gpg"
gpg --homedir "$GPG_LOCATION" --no-tty --batch --yes --import < "$GPG_RAMDISK_LOCATION/sec_keyring.gpg"
gpg --homedir "$GPG_LOCATION" --no-tty --batch --yes --import-ownertrust < "$GPG_RAMDISK_LOCATION/gpg_trust.txt"
find "$GPG_RAMDISK_LOCATION" -name "*conf" -exec cp {} "$GPG_LOCATION"  \;
gpgconf --kill all; sleep 2; gpgconf --launch all
