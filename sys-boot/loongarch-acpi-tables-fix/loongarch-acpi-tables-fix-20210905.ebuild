# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fixed ACPI tables for LoongArch"
HOMEPAGE="https://github.com/sunhaiyong1978/CLFS-for-LoongArch"
# TODO: confirm with relevant ppl
LICENSE="GPL-2"
SLOT="0"

SRC_URI="https://github.com/sunhaiyong1978/CLFS-for-LoongArch/releases/download/20210903/acpi-update-20210905.tar.gz"
RESTRICT="mirror"
KEYWORDS="~loong"

IUSE="+dracut +initrd"

RDEPEND="
	dracut? (
		sys-kernel/dracut
	)
"
DEPEND=""
BDEPEND="
	initrd? (
		app-arch/cpio
	)
"

S="${WORKDIR}/acpi-update-${PV}"

src_prepare() {
	default

	# remove unnecessary directory
	rmdir dev || true
}

src_compile() {
	if use initrd; then
		find . -print0 | \
			sort -z | \
			cpio --reproducible --null -R '0:0' -H newc -o --quiet > "${WORKDIR}"/loongarch-acpi-initrd.img
	fi
}

src_install() {
	insinto /opt/loongarch-acpi-tables-fix
	doins kernel/firmware/acpi/*

	if use dracut; then
		insinto /etc/dracut.conf.d
		doins "${FILESDIR}"/10-loongarch-acpi-tables-fix.conf
	fi

	if use initrd; then
		insinto /boot
		doins "${WORKDIR}"/loongarch-acpi-initrd.img
	fi
}
