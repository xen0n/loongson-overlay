# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="LoongArch old-world ABI compatibility layer from AOSC OS"
HOMEPAGE="https://github.com/shankerwangmiao/liblol"
SRC_URI="https://mirrors.tuna.tsinghua.edu.cn/anthon/debs/pool/frontier/main/libl/liblol_${PV}-0_loongarch64.deb"

# rely on the AOSC mirror for now
RESTRICT="strip mirror"
QA_PREBUILT="*"

# liblol itself is licensed under GPL-2 according to the AOSC maintainers.
# The bundled Loongnix libraries are way too many to manually check.
# TODO: automate license discovery from the deb package
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~loong"

IUSE="split-usr"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_install() {
	cp -r "${S}"/opt "${D}" || die

	if use split-usr; then
		insinto /lib
	else
		insinto /usr/lib
	fi
	doins -r "${S}"/usr/lib/modules-load.d

	if use split-usr; then
		dosym ../opt/lol/lib/loongarch64-aosc-linux-gnuow/ld.so.1 /lib/ld.so.1
		dosym ../lib/ld.so.1 /lib64/ld.so.1
	else
		# /lib is a symlink to /usr/lib
		dosym ../../opt/lol/lib/loongarch64-aosc-linux-gnuow/ld.so.1 /usr/lib/ld.so.1
		dosym ../lib/ld.so.1 /usr/lib64/ld.so.1
	fi
}
