#!/bin/sh
PRINTENV="/usr/sbin/fw_printenv"
SETENV="/usr/sbin/fw_setenv"
CUT="/usr/bin/cut"

echo 'Chekcing executables fw_printenv, fw_setenv and cut...'
for EXECUTABLE in $PRINTENV $SETENV; do
    $EXECUTABLE -h 2>/dev/null
    if [ $? != 0 ]; then
        echo "Error: executable $EXECUTABLE is invalid"
        exit
    fi
done

env_default() {
    echo 'Resting envs...'
    ENV_DEFAULT='/etc/env_default'
    if [ -f $ENV_DEFAULT ]; then
        ENV_EMPTY='/tmp/env_empty'
        $PRINTENV | $CUT -d '=' -f 1 > $ENV_EMPTY
        $SETENV --script $ENV_EMPTY
        $SETENV --script $ENV_DEFAULT
        echo 'Envs reset to default'
    else
        echo "Error: can not find stored default envs, check if $ENV_DEFAULT exist"
        exit
    fi
}

env_set_safe() {
    # Usage: safe_set_env [name] [value] ([default])
    local ENV_KEY="$1"
    local ENV_VALUE="$2"
    local ENV_DEFAULT="$3"
    local ENV_EXIST=$($PRINTENV -n "$1" 2>/dev/null)
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

env_get() {
    ENV_VALUE=$($PRINTENV -n $1) 2>/dev/null
}