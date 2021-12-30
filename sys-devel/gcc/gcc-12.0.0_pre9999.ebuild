# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PATCH_GCC_VER="12.0.0"
PATCH_VER="2"

inherit toolchain

# Don't keyword live ebuilds
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"

# add LoongArch port and further upstream-friendly customizations
EGIT_REPO_URI="https://github.com/xen0n/gcc.git"
EGIT_BRANCH=for-gentoo-gcc-12-v6

RDEPEND=""
BDEPEND="${CATEGORY}/binutils"
