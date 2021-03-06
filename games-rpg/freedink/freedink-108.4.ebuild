# Copyright 2014 Julian Ospald <hasufell@posteo.de>
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Dink Smallwood is an adventure/role-playing game, similar to Zelda (2D top view)"
HOMEPAGE="http://www.freedink.org/"
SRC_URI="mirror://gnu/freedink/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND="
	>=media-libs/fontconfig-2.4
	>=media-libs/libsdl-1.2[X,sound,joystick,video]
	>=media-libs/sdl-gfx-2.0
	>=media-libs/sdl-image-1.2
	>=media-libs/sdl-mixer-1.2[midi,vorbis,wav]
	>=media-libs/sdl-ttf-2.0.9"
RDEPEND="${DEPEND}
	~games-rpg/freedink-data-1.08.20140901"
DEPEND="${DEPEND}
	dev-libs/check
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	sed -i \
		-e 's#^datarootdir =.*$#datarootdir = /usr/share#' \
		share/Makefile.in || die
}

src_configure() {
	econf \
		--disable-embedded-resources \
		--localedir="/usr/share/locale" \
		$(use_enable nls)
}

src_install() {
	default
	dodoc TROUBLESHOOTING
}

pkg_postinst() {
	einfo
	elog "optional dependencies:"
	elog "  games-util/dfarc (dmod installer and frontend)"
	einfo
}

