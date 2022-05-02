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
[[ -z "$($MOUNT | $GREP /dev/data)" ]] && echo 'ERROR: The data partition is not currently mounted, which suggests you may not be running from emmc, refuse to continue.' && exit 1


read -p 'WARNING: Resizing the data partition is only reasonable if you have modded the onboard emmc chip. Online resizing from emmc is extremely dangerous. You could even brick your box if you lose your power during the operation. Type "yes" if you know what you are doing:' CHOICE
[[ "$CHOICE" != 'yes' ]] && exit

SYSTEMCTL='/usr/bin/systemctl'
MOUNT='/usr/bin/mount'
E2FSCK='/usr/sbin/e2fsck'
RESIZE2FS='/usr/sbin/resize2fs'
DATA='/dev/data'
echo 'Stopping kodi so we can remount data as read-only...'
$SYSTEMCTL stop kodi
$MOUNT -o ro,remount $DATA /storage
echo 'Checking filesystem, losing power during the following step will be fatal.'
$E2FSCK -f $DATA
echo 'Mounting data as read-write again'
$MOUNT -o rw,remount $DATA /storage
echo 'Resizing filesystem, losing power during the following step will be fatal.'
$RESIZE2FS $DATA
echo "Resize complete"