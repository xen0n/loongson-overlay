# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bootstrap package for dev-lang/go"
HOMEPAGE="https://golang.org"
BOOTSTRAP_DIST="https://dev.gentoo.org/~xen0n/distfiles"
SRC_URI="
	loong? ( ${BOOTSTRAP_DIST}/go-linux-loong64-bootstrap-1.19-0a1a092c4b.tbz )
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~loong"
RESTRICT="strip"
QA_PREBUILT="*"

S="${WORKDIR}"

src_install() {
	dodir /usr/lib
	mv go-*-bootstrap "${ED}/usr/lib/go-bootstrap" || die

	# testdata directories are not needed on the installed system
	rm -fr $(find "${ED}"/usr/lib/go -iname testdata -type d -print)
}
