#!/bin/sh

PRINTENV="/usr/sbin/fw_printenv"
SETENV="/usr/sbin/fw_setenv"

function safe_set_env() {
    # Usage: safe_set_env [name] [value] ([default])
    
    local ENV_KEY="$1"
    local ENV_VALUE="$2"
    local ENV_DEFAULT="$3"
    local ENV_EXIST=$($PRINTENV -n  "$1") 2>/dev/null
    if [[ $? == 0 ]]; then
        if [[ "$ENV_EXIST" == "$ENV_VALUE" ]]; then
            echo "Note: u-boot environment '$ENV_KEY' is already set, no need to update"
        elif [[ "$ENV_EXIST" == "$ENV_DEFAULT" ]]; then
            $SETENV "$ENV_KEY" "$ENV_VALUE"
        else
            echo "ERROR: u-boot environment '$ENV_KEY' already set and differs from default value, refuse to update u-boot"
            exit 1
        fi
    else
        $SETENV "$ENV_KEY" "$ENV_VALUE"
    fi
}

safe_set_env storeboot 'run storeargs; ${bootcmd}'
safe_set_env dtb_mem_addr 1000000
safe_set_env bootfromnand 0
safe_set_env upgrade_step 2 2
safe_set_env usbdtb 'if fatload usb 0 ${dtb_mem_addr} dtb.img; then else store dtb read $dtb_mem_addr; fi'
safe_set_env bootfromusb 'usb start 0; if fatload usb 0 ${loadaddr} kernel.img; then run usbdtb; setenv bootargs ${bootargs} bootfromusb; bootm; fi'
safe_set_env bootcmd 'if test ${bootfromnand} = 1; then setenv bootfromnand 0; saveenv; else run bootfromusb; fi; run storeboot' 'run boot_from_flash'

echo "Enabled USB booting"