# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bootstrap package for dev-lang/go"
HOMEPAGE="https://golang.org"
SRC_URI="
	loong? ( https://github.com/Rabenda/loongson-overlay/releases/download/bootstrap-dist/go-linux-loong64-bootstrap.tbz )
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~loong"
IUSE="big-endian"
RESTRICT="strip"
QA_PREBUILT="*"

S="${WORKDIR}"

src_install() {
	dodir /usr/lib
	mv go-*-bootstrap "${ED}/usr/lib/go-bootstrap" || die

	# testdata directories are not needed on the installed system
	rm -fr $(find "${ED}"/usr/lib/go -iname testdata -type d -print)
}
