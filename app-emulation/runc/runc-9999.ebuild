# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib

DESCRIPTION="runc container cli tools"
HOMEPAGE="http://runc.io"

GITHUB_URI="github.com/opencontainers/runc"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://${GITHUB_URI}.git"
	inherit git-r3
else
	SRC_URI="https://${GITHUB_URI}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="apparmor +seccomp"

DEPEND=">=dev-lang/go-1.4:="
RDEPEND="
	apparmor? ( sys-libs/apparmor )
	seccomp? ( sys-libs/libseccomp )
	!app-emulation/docker-runc"

src_compile() {
	# disable pie build for mips
	if use mips; then
		sed -i 's/-buildmode=pie//g' Makefile
	fi

	# restructure vendor to vendor/src
	mv vendor src
	mkdir vendor
	mv src vendor/src

	# Taken from app-emulation/docker-1.7.0-r1
	export CGO_CFLAGS="-I${ROOT}/usr/include"
	export CGO_LDFLAGS="-L${ROOT}/usr/$(get_libdir)"

	# Setup GOPATH so things build
	rm -rf .gopath
	mkdir -p .gopath/src/"$(dirname "${GITHUB_URI}")"
	ln -sf ../../../.. .gopath/src/"${GITHUB_URI}"
	export GOPATH="${PWD}/.gopath:${PWD}/vendor"

	# build up optional flags
	local options=( $(usex apparmor "apparmor") $(usex seccomp "seccomp") )

	emake BUILDTAGS="${options[*]}"
}

src_install() {
	dobin runc
}
