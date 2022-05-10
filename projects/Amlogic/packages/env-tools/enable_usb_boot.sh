#!/bin/bash

. /usr/sbin/fw_functions.sh

ENV_VALUE=''

env_get bootfromnand
if [ -n "$ENV_VALUE" ]; then
    echo 'USB booting is already activated, no need to enable it'
else
    env_default
    echo 'Enabling USB booting...'
    env_get bootcmd
    $SETENV storeboot "run storeargs; $ENV_VALUE"
    env_get dtb_mem_addr
    [ -z "$ENV_VALUE" ] && $SETENV dtb_mem_addr 1000000
    $SETENV bootfromnand 0
    $SETENV upgrade_step 2
    $SETENV usbdtb 'if fatload usb 0 ${dtb_mem_addr} dtb.img; then else store dtb read ${dtb_mem_addr}; fi'
    $SETENV boot_from_usb 'usb start 0; if fatload usb 0 ${loadaddr} kernel.img; then run usbdtb; setenv bootargs ${bootargs} bootfromusb; bootm; fi'
    $SETENV bootcmd 'if itest ${bootfromnand} == 1; then setenv bootfromnand 0; saveenv; else run boot_from_usb; fi; run storeboot'
fi

echo "Enabled USB booting"