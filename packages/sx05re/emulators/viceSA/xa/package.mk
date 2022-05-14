# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="xa"
PKG_VERSION="2.3.10"
PKG_SHA256="c1e7bb04ddfeab9d25133d7cdc072a3d94ae260dce053abb4bb4d4288b42d14e"
PKG_ARCH="any"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/fachat/xa65"
PKG_URL="$PKG_SITE/archive/refs/tags/xa-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_LONGDESC="xa is a high-speed, two-pass portable cross-assembler. It understands mnemonics and generates code for NMOS 6502s (such as 6502A, 6504, 6507, 6510, 7501, 8500, 8501, 8502 ...), CMOS 6502s (65C02 and Rockwell R65C02) and the 65816. "

makeinstall_host() {
  cp xa $TOOLCHAIN/bin/
}
