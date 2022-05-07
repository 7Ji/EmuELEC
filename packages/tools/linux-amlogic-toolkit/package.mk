# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-presetn 7Ji (pugokushin@gmail.com)

PKG_NAME="linux-amlogic-toolkit"
PKG_VERSION="5f05a88dea7b0bb321a2c84fe53d9a5b37c2c19a"
PKG_SHA256="f0ceb60524e8896702f874f352eaafdb9081212b99f53e29c3e2b00f7e38ce8f"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/natinusala/linux-amlogic-toolkit"
PKG_URL="https://github.com/natinusala/$PKG_NAME/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_LONGDESC="linux-amlogic-toolkit: Toolkit for manipulating amlogic burning tool image"
PKG_BUILD_FLAGS="+pic:host"

makeinstall_host() {
  mkdir -p $TOOLCHAIN/sbin
  cp $PKGBUILD/bin/aml_image_v2_packer $TOOLCHAIN/sbin
}