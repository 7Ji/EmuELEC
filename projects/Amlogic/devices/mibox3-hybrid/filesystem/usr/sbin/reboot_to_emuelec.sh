#!/bin/bash

. /usr/sbin/fw_functions.sh

GREP="/usr/bin/grep"
ENV_VALUE=''

# Activate dualboot if not yet
env_get boot_emuelec
if [ -n "$ENV_VALUE" ]; then
    echo 'EmuELEC is already bootable, no need to enable it'
else
    env_default
    echo "Enabling booting EmuELEC..."
    env_get bootcmd
    $SETENV storeboot "run storeargs; $ENV_VALUE"
    $SETENV dtb_mem_addr 1000000
    $SETENV bootfromnand 0
    $SETENV bootemuelec 1
    $SETENV upgrade_step 2
    $SETENV usbdtb 'if fatload usb 0 ${dtb_mem_addr} dtb.img; then else store dtb read ${dtb_mem_addr}; fi'
    $SETENV boot_from_usb 'usb start 0; if fatload usb 0 ${loadaddr} kernel.img; then run usbdtb; setenv bootargs ${bootargs} bootfromusb; bootm; fi'
    $SETENV boot_from_emmc 'if itest ${bootemuelec} == 1; then imgread kernel boot_emuelec ${loadaddr}; else imgread kernel boot ${loadaddr}; fi; bootm'
    $SETENV bootcmd 'if itest ${bootfromnand} == 1; then setenv bootfromnand 0; saveenv; else run boot_from_usb; fi; run boot_from_emmc; run storeboot'
fi

env_set boot_emuelec 1