# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fixed ACPI tables for LoongArch"
HOMEPAGE="https://github.com/sunhaiyong1978/CLFS-for-LoongArch"
LICENSE="all-rights-reserved"
SLOT="0"

SRC_URI="https://github.com/sunhaiyong1978/CLFS-for-LoongArch/releases/download/20210903/acpi-update-20210905.tar.gz"
RESTRICT="mirror"
KEYWORDS="~loong"

IUSE=""

RDEPEND=""
DEPEND=""
BDEPEND="
	app-arch/cpio
"

S="${WORKDIR}/acpi-update-${PV}"

src_prepare() {
	default

	# remove unnecessary directory
	rmdir dev || true
}

src_compile() {
	find . -print0 | \
		sort -z | \
		cpio --reproducible --null -R '0:0' -H newc -o --quiet > "${WORKDIR}"/loongarch-acpi-initrd.img
}

src_install() {
	insinto /opt/loongarch-acpi-tables-fix
	doins kernel/firmware/acpi/*

	insinto /etc/dracut.conf.d
	doins "${FILESDIR}"/10-loongarch-acpi-tables-fix.conf

	insinto /boot
	doins "${WORKDIR}"/loongarch-acpi-initrd.img
}
