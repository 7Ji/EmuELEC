# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-2018 Team LibreELEC (https://libreelec.tv)
# Copyright (C) 2018-2022 Team CoreELEC (https://coreelec.org)
# Copyright (C) 2022-present 7Ji (pugokushin@gmail.com)

PKG_NAME="device-trees-amlogic"
PKG_VERSION="fcf78f8e6f20b7a42b89641099389ad0337d0bf4"
PKG_SHA256="edcf668e52c44d0eae49ce67a1adabcd25f5b94f3c0e4d1ed1c806769d04961e"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/7Ji/device-trees-amlogic"
PKG_URL="https://github.com/7Ji/device-trees-amlogic/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_UNPACK="linux"
PKG_LONGDESC="Device trees for Amlogic devices."
PKG_IS_KERNEL_PKG="yes"
PKG_TOOLCHAIN="manual"

make_target() {
  # Enter kernel directory
  pushd $BUILD/linux-$(kernel_version) > /dev/null

  DTB_NAME="gxbb_p200_1G_mibox3"
  cp -f $PKG_BUILD/$DTB_NAME.dts arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/

  # Compile device trees
  kernel_make ${DTB_NAME}.dtb
  cp arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/${DTB_NAME}.dtb $PKG_BUILD

  popd > /dev/null
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/bootloader
  cp -a $PKG_BUILD/gxbb_p200_1G_mibox3.dtb $INSTALL/usr/share/bootloader/dtb.img
}
