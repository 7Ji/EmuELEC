#! /bin/sh

echo "WARNING: The script does not have any safeguards, you will not receive any"
echo "support for problems that you may encounter if you proceed!"

CAT='/usr/bin/cat'

EMMC_SIZE=$($CAT /sys/block/mmcblk0/size)
[[ $? != 0 ]] && echo "ERROR: Can not get size of emmc, check if you are running 7Ji's patched kernel." && exit 1
[[ "$EMMC_SIZE" == 7733248 ]] && echo "ERROR: Size of emmc is 3776 MiB, you are using the stock emmc chip, refuse to continue" && exit 1

DATA_SIZE=$($CAT /sys/block/mmcblk0/data/size)
[[ $? != 0 ]] && echo "ERROR: Can not get size of data partition, check if you are running 7Ji's patched kernel." && exit 1
#[[ "$DATA_SIZE" != 3825664 ]] && echo "ERROR: Size of data partition is not 1868 MiB, you may already resized the partition, refuse to continue" && exit 1

MOUNT='/usr/bin/mount'
GREP='/usr/bin/grep'
[[ ! -z "$($MOUNT | $GREP /dev/data)" ]] && echo 'ERROR: The data partition is currently mounted, which suggests you may be running from emmc, refuse to continue.' && exit 1

read -p 'WARNING: Resizing the data partition is only reasonable if you have modded the onboard emmc chip. Type "yes" if you know what you are doing:' CHOICE
[[ "$CHOICE" != 'yes' ]] && exit

DEV_LOOP='/dev/loop7'
DEV_EMMC='/dev/mmcblk0'
LOSETUP='/usr/sbin/losetup'
E2FSCK='/usr/sbin/e2fsck'
RESIZE2fs='/usr/sbin/resize2fs'

attach() {
    $LOSETUP -o "${1}M" "$DEV_LOOP" "$DEV_EMMC"
}
detach() {
    $LOSETUP -D "$DEV_LOOP"
}
safe_exit() {
    detach
    exit $1
}
attach 1908 || safe_exit 1
$E2FSCK -f "$DEV_LOOP"
$RESIZE2fs "$DEV_LOOP"
detach 0

echo "Resize complete, you may try to reboot to emmc know."