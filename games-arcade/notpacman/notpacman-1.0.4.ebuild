# Copyright 2014 Julian Ospald <hasufell@posteo.de>
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils

DESCRIPTION="A mashup of \"Not\" and \"Pacman\""
HOMEPAGE="http://stabyourself.net/notpacman/"
SRC_URI="http://stabyourself.net/dl.php?file=notpacman-1004/notpacman-linux.zip -> ${P}.zip
	http://dev.gentoo.org/~hasufell/distfiles/${PN}.png"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LVSLOT="0.7"
RDEPEND=">=games-engines/love-0.7.2:${LVSLOT}
	 media-libs/devil[png]"
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	local dir=/usr/share/love/${PN}

	exeinto "${dir}"
	newexe not_pacman.love ${PN}.love

	dodoc README

	doicon -s 32 "${DISTDIR}"/${PN}.png
	make_wrapper ${PN} "love-${LVSLOT} ${PN}.love" "${dir}"
	make_desktop_entry ${PN}
}

