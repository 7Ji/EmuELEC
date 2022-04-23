# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-presetn 7Ji (pugokushin@gmail.com)

PKG_NAME="android-simg2img"
PKG_VERSION="1.1.4"
PKG_SHA256="cbd32490c1e29d9025601b81089b5aec1707cb62020dfcecd8747af4fde6fecd"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/anestisb/android-simg2img"
PKG_URL="https://github.com/anestisb/$PKG_NAME/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="toolchain zlib:host"
PKG_LONGDESC="android-simg2img: Tool for converting between raw disk image and android sparse img"
PKG_BUILD_FLAGS="+pic:host"

make_host() {
  make img2simg
}

makeinstall_host() {
  $STRIP $PKG_BUILD/img2simg

  mkdir -p $TOOLCHAIN/sbin
  cp $PKG_BUILD/img2simg $TOOLCHAIN/sbin
}