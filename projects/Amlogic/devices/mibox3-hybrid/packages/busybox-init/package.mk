# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present 7Ji (pugokushin@gmail.com)

PKG_NAME="busybox-init"
PKG_VERSION="1.0"
PKG_LICENSE="GPL"
PKG_SITE="https://7ji.github.io"
PKG_URL=""
PKG_DEPENDS_TARGET="busybox"
PKG_DEPENDS_INIT="busybox"
PKG_LONGDESC="Custom init for mibox3 CoreELEC/EmuELEC hybrid booting"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  cp $PKG_DIR/init $INSTALL
  chmod 755 $INSTALL/init
}

