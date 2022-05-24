# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="昇龍 -- upgrades LoongArch sysroot in-place to new glibc symbol version"
HOMEPAGE="https://github.com/xen0n/shengloong"
SRC_URI="mirror+https://github.com/xen0n/shengloong/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~loong"
IUSE="nls"

DEPEND="
	dev-libs/popt
	virtual/libelf:=
	nls? ( virtual/libintl )
"
RDEPEND="${DEPEND}"

BDEPEND="
	>=dev-util/meson-0.61.0
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_configure() {
	local emesonargs=(
		$(meson_feature nls)
	)

	meson_src_configure
}

src_test() {
	# don't try to run the loong binaries: emulation might not be available
	# on non-loong, while sandbox would break on sysroot with different glibc
	# symver on loong.
	CI=true meson_src_test
}
