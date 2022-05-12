#!/bin/bash

. /usr/sbin/fw_functions.sh

ENV_VALUE=''

env_get bootfromnand
if [ -n "$ENV_VALUE" ]; then
    echo 'USB booting to extlinux (Armbian/Openwrt) is already activated, no need to enable it'
else
    env_default
    echo 'Enabling USB booting to extlinux (Armbian/Openwrt)...'
    $SETENV bootfromrecovery 0
    $SETENV bootfromnand 0
    $SETENV start_usb_autoscript "if fatload usb 0 11000000 aml_autoscript; then autoscr 11000000; fi; if fatload usb 1 11000000 aml_autoscript; then autoscr 11000000; fi;"
    $SETENV boot_from_usb 'if usb start; then run start_usb_autoscript; fi;'
    env_get dtb_mem_addr
    [ -z "$ENV_VALUE" ] && $SETENV dtb_mem_addr 1000000
    env_get bootcmd
    $SETENV storeboot "run storeargs; $ENV_VALUE"
    $SETENV bootcmd 'if itest ${bootfromnand} == 1; then setenv bootfromnand 0; saveenv; else run boot_from_usb; fi; run storeboot'
fi

echo "Enabled USB booting to extlinux (Armbian/Openwrt)"