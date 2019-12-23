#!/bin/sh
#

help(){
	cat << HELP

 chroot into a rootfs for the same architecture
 usage: sudo $(basename $0) rootdir

HELP
}

[[ -d ${1:-} ]] || { help && exit; }


echo chrooting into $1
mkdir -p $1/proc
mkdir -p $1/sys
mkdir -p $1/dev

cp /etc/resolv.conf $1/etc

mount --bind /proc $1/proc
mount --bind /sys $1/sys
mount --bind /dev $1/dev
mount --bind /dev/pts $1/dev/pts

chroot $1 /bin/bash

echo "Cleaning up..."
umount $1/dev/pts
umount $1/dev
umount $1/sys
umount $1/proc || umount -lf $1/proc

rm $1/etc/resolv.conf 2> /dev/null
rm $1/var/lib/dbus/machine-id 2> /dev/null

echo "Done."
