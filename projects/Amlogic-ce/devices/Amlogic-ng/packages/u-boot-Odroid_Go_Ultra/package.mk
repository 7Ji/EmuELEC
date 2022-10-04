# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present 7Ji (https://github.com/7Ji)

PKG_NAME="u-boot-Odroid_Go_Ultra"
PKG_VERSION="d89910f962ec610fe94c0d7b3423e7fc74c8a95c"
PKG_SHA256="473a711ca588fdf1e18f78134e03a06df643be1f60d827422e946f6e97a76308"
PKG_LICENSE="GPL"
PKG_SITE="https://www.denx.de/wiki/U-Boot"
PKG_URL="https://github.com/hardkernel/u-boot/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain gcc-linaro-aarch64-elf:host gcc-linaro-arm-eabi:host"
PKG_LONGDESC="Das U-Boot is a cross-platform bootloader for embedded systems."
PKG_TOOLCHAIN="manual"

pre_make_target() {
  sed -i "s|aarch64-none-elf-|aarch64-elf-|g" $PKG_BUILD/Makefile 2>/dev/null || true
  sed -i "s|arm-none-eabi-|arm-eabi-|g" $PKG_BUILD/arch/arm/cpu/armv8/*/firmware/scp_task/Makefile 2>/dev/null || true
}

configure_package() {
  PKG_UBOOT_CONFIG="odroidgou_defconfig"
}

make_target() {
  [ "${BUILD_WITH_DEBUG}" = "yes" ] && PKG_DEBUG=1 || PKG_DEBUG=0
  export PATH=$TOOLCHAIN/lib/gcc-linaro-aarch64-elf/bin/:$TOOLCHAIN/lib/gcc-linaro-arm-eabi/bin/:$PATH
  DEBUG=${PKG_DEBUG} CROSS_COMPILE=aarch64-elf- ARCH=arm CFLAGS="" LDFLAGS="" make mrproper
  DEBUG=${PKG_DEBUG} CROSS_COMPILE=aarch64-elf- ARCH=arm CFLAGS="" LDFLAGS="" make $PKG_UBOOT_CONFIG
  DEBUG=${PKG_DEBUG} CROSS_COMPILE=aarch64-elf- ARCH=arm CFLAGS="" LDFLAGS="" make HOSTCC="$HOST_CC" HOSTSTRIP="true"
}

makeinstall_target() {
  : # nothing
}
