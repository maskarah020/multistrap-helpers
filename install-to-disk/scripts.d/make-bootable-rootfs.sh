#!/bin/bash

if [ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ]; then
  echo "Preparing bootable rootfs"
else
  echo "This script is intended to be run in chroot environment!"
  exit 1
fi

apt-get install linux-image-amd64 \
	grub2 \
	systemd \
	initramfs-tools \
	kbd
[[ -e /sbin/init ]] || ln -s /lib/systemd/systemd /sbin/init

# edit initramfs.conf to change KEYMAP=y
CONFIG_FILE=/etc/initramfs-tools/initramfs.conf
KEY="KEYMAP"
VALUE="y"
sed -i "s/^\($KEY\s*=\s*\).*\$/\1$VALUE/" $CONFIG_FILE

# Prevent "root account is locked" error:
echo "Create a password for your root account:"
passwd

update-initramfs -u
echo "Done."
