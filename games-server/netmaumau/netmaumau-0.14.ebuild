# Copyright 2015 Julian Ospald <hasufell@posteo.de>, Heiko Schaefer <heiko@rangun.de>
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools flag-o-matic eutils libtool vcs-snapshot

DESCRIPTION="Server for the popular card game Mau Mau"
HOMEPAGE="http://sourceforge.net/projects/netmaumau"
SRC_URI="https://github.com/velnias75/NetMauMau/archive/V${PV}.tar.gz -> ${P}-server.tar.gz"

LICENSE="LGPL-3"
SLOT="0/6"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs cli-client branding"

RDEPEND="
	>=dev-libs/popt-1.10
	>=sci-libs/gsl-1.9
	sys-apps/file
	dev-db/sqlite:3
"
DEPEND="${RDEPEND}
	app-editors/vim-core
	sys-apps/help2man
	virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.8.0 )
"

S=${WORKDIR}/${P}-server

src_prepare() {
	eautoreconf
}

src_configure() {
	append-cppflags -DNDEBUG

	use branding && AI_NAME="Gentoo Hero"

	econf \
		--enable-client \
		--enable-xinetd \
		$(use_enable cli-client) \
		$(use_enable doc apidoc) \
		--docdir=/usr/share/doc/${PF} \
		--localstatedir=/var/lib/games/ \
		$(use_enable static-libs static) \
		"$(use_enable branding ai-name "$AI_NAME")" \
		$(use_enable branding ai-image "${FILESDIR}"/gblend.png)
}

src_install() {
	default
	prune_libtool_files
	keepdir "${ROOT}"/var/lib/games/netmaumau
	fowners nobody:nogroup "${ROOT}"/var/lib/games/netmaumau
}

pkg_postinst() {
	elog "This is only the server part, you might want to install"
	elog "the client too:"
	elog "  games-board/netmaumau"
	elog
	elog "This server also installs a xinetd service. You need"
	elog "  sys-apps/xinetd"
	elog "if you want to get the server started on demand."
}
