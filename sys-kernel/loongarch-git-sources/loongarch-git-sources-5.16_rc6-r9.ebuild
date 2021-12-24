# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_NOUSEPR="yes"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_FROM_GIT="yes"
ETYPE="sources"

# only use this if it's not an _rc/_pre release
[ "${PV/_pre}" == "${PV}" ] && [ "${PV/_rc}" == "${PV}" ] && OKV="${PV}"
inherit kernel-2
detect_version
detect_arch

inherit git-r3
EGIT_REPO_URI="https://github.com/xen0n/linux.git -> loongarch-linux.git"
EGIT_BRANCH="loongarch-playground-v${PR##r}"
EGIT_CHECKOUT_DIR="${WORKDIR}/linux-${PV/_rc/-rc}"
EGIT_CLONE_TYPE="shallow"

DESCRIPTION="The loongarch-next version of the Linux kernel, with minimal xen0n patches"
HOMEPAGE="https://github.com/xen0n/linux"
#SRC_URI="${KERNEL_URI}"

KEYWORDS="~loong"
IUSE=""

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its unstable and
experimental nature. If you have any issues, try a matching vanilla-sources
ebuild -- if the problem is not there, please contact the upstream kernel
developers at https://bugzilla.kernel.org and on the linux-kernel mailing list to
report the problem so it can be fixed in time for the next kernel release."

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/patch-2.7.5"

src_unpack() {
	git-r3_src_unpack
	unpack_set_extraversion
}

pkg_postinst() {
	postinst_sources
}
