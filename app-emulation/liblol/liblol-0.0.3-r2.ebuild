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
#KEYWORDS="-* ~loong"

IUSE="split-usr"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
PDEPEND="app-emulation/la-ow-syscall"

S="${WORKDIR}"

src_install() {
	cp -r "${S}"/opt "${D}" || die

	insinto /usr/share
	doins -r usr/share/gpudriverpath

	insinto /usr/share/liblol
	doins "${FILESDIR}"/*.in

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

_render_cache_file() {
	local lol_libdir="${EROOT}/opt/lol/lib/loongarch64-aosc-linux-gnuow"
	sed -e "s#@libdir@#${lol_libdir}#g" \
		"${EROOT}"/usr/share/liblol/"$1" > "${lol_libdir}/$2"
}

_populate_caches() {
	ebegin "Populating gdk-pixbuf loader cache for liblol"
	_render_cache_file gdk-pixbuf-query-loaders.cache.in \
		gdk-pixbuf-2.0/2.10.0/loaders.cache || die
	eend $?

	ebegin "Populating gtk2 input method module cache for liblol"
	_render_cache_file gtk2-immodules.cache.in \
		gtk-2.0/2.10.0/immodules.cache || die
	eend $?

	ebegin "Populating gtk3 input method module cache for liblol"
	_render_cache_file gtk3-immodules.cache.in \
		gtk-3.0/3.0.0/immodules.cache || die
	eend $?

	ebegin "Populating GIO modules cache for liblol"
	_render_cache_file giomodule.cache.in \
		gio/modules/giomodule.cache || die
	eend $?
}

pkg_preinst() {
	_populate_caches
}

pkg_prerm() {
	local lol_libdir="${EROOT}/opt/lol/lib/loongarch64-aosc-linux-gnuow"
	rm "${lol_libdir}/gdk-pixbuf-2.0/2.10.0/loaders.cache"
	rm "${lol_libdir}/gtk-2.0/2.10.0/immodules.cache"
	rm "${lol_libdir}/gtk-3.0/3.0.0/immodules.cache"
	rm "${lol_libdir}/gio/modules/giomodule.cache"
}
