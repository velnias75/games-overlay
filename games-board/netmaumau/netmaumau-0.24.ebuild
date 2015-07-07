# Copyright 2015 Julian Ospald <hasufell@posteo.de>, Heiko Schaefer <heiko@rangun.de>
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qmake-utils eutils vcs-snapshot fdo-mime gnome2-utils

MY_P=nmm-qt-client${PV}

DESCRIPTION="Client for games-server/netmaumau, the popular card game Mau Mau"
HOMEPAGE="http://sourceforge.net/projects/netmaumau"
SRC_URI="https://github.com/velnias75/NetMauMau-Qt-Client/archive/V${PV}.tar.gz -> ${P}-client.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+espeak"

RDEPEND="
	dev-libs/libnotify-qt
	dev-libs/qgithubreleaseapi[qt4]
	dev-qt/qtcore:4[exceptions]
	dev-qt/qtgui:4[exceptions]
	dev-qt/qtsvg:4[exceptions]
	dev-qt/qtsingleapplication[qt4]
	espeak? ( || ( app-accessibility/espeak[portaudio] app-accessibility/espeak[pulseaudio] ) )
	games-server/netmaumau:0/13[-dedicated]
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

S=${WORKDIR}/${P}-client

src_configure() {

	if [ -f "${S}/src/src.pro" ]; then
                MY_SRCDIR="${S}/src"
        elif [ -f "${S}/src.pro" ]; then
                MY_SRCDIR="${S}"
        else
                die "Cannot find src.pro"
        fi

	lrelease -compress -nounfinished -removeidentical -silent "${MY_SRCDIR}/src.pro"

	if use espeak; then USE_ESPEAK='CONFIG+=espeak'; fi
	eqmake4 CONFIG+=system_qtsingleapplication CONFIG+=notify-qt $USE_ESPEAK
}

src_install() {

	dobin "${MY_SRCDIR}/nmm-qt-client"
	dodoc "${MY_SRCDIR}/THANKS"
	doicon -s 256 "${MY_SRCDIR}/nmm_qt_client.png"
	domenu "${MY_SRCDIR}/nmm_qt_client.desktop"
	insinto /usr/share/nmm-qt-client

	for MYQM in `find "${S}" -name '*.qm'` ; do
		doins "${MYQM}"
	done
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
