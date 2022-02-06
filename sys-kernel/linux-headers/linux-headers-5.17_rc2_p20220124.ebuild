# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ETYPE="headers"
H_SUPPORTEDARCH="alpha amd64 arc arm arm64 avr32 cris frv hexagon hppa ia64 loong m68k metag microblaze mips mn10300 nios2 openrisc ppc ppc64 riscv s390 score sh sparc x86 xtensa"
K_BASE_VER="5.16"
CKV="$(ver_cut 1-4)"
inherit kernel-2 toolchain-funcs
detect_version

PATCH_PV="$K_BASE_VER" # to ease testing new versions against not existing patches
PATCH_VER="0"
PATCH_DEV="soap"
LOONGARCH_NEXT_PATCH_VER="20220124"
SRC_URI="${KERNEL_URI}
	${PATCH_VER:+https://dev.gentoo.org/~${PATCH_DEV}/distfiles/sys-kernel/linux-headers/gentoo-headers-${PATCH_PV}-${PATCH_VER}.tar.xz}
	${LOONGARCH_NEXT_PATCH_VER:+https://loongson-patchballs-glb.qnbkt.xen0n.name/loongarch-next-on-${KV_FULL}-${LOONGARCH_NEXT_PATCH_VER}.tar.xz}"
S="${WORKDIR}/linux-${KV_FULL}"

# This is for testing the LoongArch port only.
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
KEYWORDS="~loong"

BDEPEND="app-arch/xz-utils
	dev-lang/perl"

# bug #816762
RESTRICT="test"

[[ -n ${PATCH_VER} ]] && PATCHES=( "${WORKDIR}"/${PATCH_PV} )
[[ -n ${LOONGARCH_NEXT_PATCH_VER} ]] && PATCHES+=( "${WORKDIR}"/loongarch-next-on-${KV_FULL} )

src_unpack() {
	unpack "gentoo-headers-${PATCH_PV}-${PATCH_VER}.tar.xz"
	unpack "loongarch-next-on-${KV_FULL}-${LOONGARCH_NEXT_PATCH_VER}.tar.xz"
	kernel-2_src_unpack
}

src_prepare() {
	if use elibc_musl ; then
		# TODO: May need forward porting to newer versions
		eapply "${FILESDIR}"/${PN}-5.10-Use-stddefs.h-instead-of-compiler.h.patch
		eapply "${FILESDIR}"/${PN}-5.15-remove-inclusion-sysinfo.h.patch
	fi

	# avoid kernel-2_src_prepare
	default
}

src_test() {
	emake headers_check ${xmakeopts}
}

src_install() {
	kernel-2_src_install

	find "${ED}" \( -name '.install' -o -name '*.cmd' \) -delete || die
}
