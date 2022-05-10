# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present 7Ji (pugokushin@gmail.com)

PKG_NAME="env-tools"
PKG_VERSION="1.0"
PKG_LICENSE="GPL"
PKG_SITE="https://7ji.github.io"
PKG_URL=""
PKG_DEPENDS_TARGET="u-boot-tools-aml"
PKG_LONGDESC="Tools for easily edit envs, mainly for mibox3"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p $INSTALL/etc
  # env_default is defined per device
  find_file_path env_default
  cp $FOUND_PATH $INSTALL/etc/

  mkdir -p $INSTALL/usr/sbin
  cp $PKG_DIR/fw_functions.sh $INSTALL/usr/sbin/

  if [ "$PROFILE" = "hybrid" ]; then
    cp $PKG_DIR/reboot_to_coreelec.sh $INSTALL/usr/sbin/
  elif [ "$PROFILE" = "extreme" ]; then
    cp $PKG_DIR/enable_usb_boot.sh $INSTALL/usr/sbin/
  fi
}