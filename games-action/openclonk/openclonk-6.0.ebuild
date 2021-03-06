# Copyright 2014 Julian Ospald <hasufell@posteo.de>
# Distributed under the terms of the GNU General Public License v2

# FIXME: does not compile with gtk+3

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit cmake-utils eutils gnome2-utils python-any-r1 fdo-mime

MY_P=${PN}-release-${PV}-src

DESCRIPTION="A free multiplayer action game where you control clonks"
HOMEPAGE="http://openclonk.org/"
SRC_URI="http://www.openclonk.org/builds/release/${PV}/openclonk-${PV}-src.tar.bz2
	http://${PN}.org/homepage/icon.png -> ${PN}.png"

LICENSE="BSD ISC CLONK-trademark LGPL-2.1 POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated doc"

RDEPEND="
	>=dev-libs/boost-1.40
	dev-libs/tinyxml
	net-libs/libupnp
	media-libs/libpng:0
	sys-libs/zlib
	!dedicated? (
		dev-libs/glib:2
		media-libs/freealut
		media-libs/freetype:2
		media-libs/glew
		media-libs/libsdl[X,opengl,sound,video]
		media-libs/libvorbis
		media-libs/openal
		media-libs/sdl-mixer[mp3,vorbis,wav]
		virtual/jpeg
		virtual/opengl
		virtual/glu
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:3
		x11-libs/libXrandr
		x11-libs/libX11
	)
	dedicated? ( sys-libs/readline:0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		${PYTHON_DEPS}
		dev-libs/libxml2[python]
		sys-devel/gettext
	)"

PATCHES=(
	"${FILESDIR}"/${P}-paths.patch
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-jpeg9.patch
	"${FILESDIR}"/${P}-tinyxml.patch
)
S=${WORKDIR}/${PN}-release-${PV}-src

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	rm -r thirdparty/tinyxml || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(usex dedicated \
			"-DUSE_CONSOLE=ON -DUSE_X11=OFF -DUSE_GTK=OFF -DUSE_GTK3=OFF" \
			"-DUSE_CONSOLE=OFF -DUSE_X11=ON -DUSE_GTK=ON -DUSE_GTK3=ON")
		-DWITH_AUTOMATIC_UPDATE=OFF
		-DINSTALL_GAMES_BINDIR="/usr/bin"
		-DINSTALL_DATADIR="/usr/share"
		-DUSE_STATIC_BOOST=OFF
		-DUSE_SYSTEM_TINYXML=ON
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc ; then
		emake -C docs
	fi
}

src_install() {
	cmake-utils_src_install

	if ! use dedicated; then
		mv "${ED%/}/usr/bin/openclonk" "${ED%/}/usr/bin/clonk" || die
		newbin "${FILESDIR}"/${PN}-wrapper-script.sh ${PN}
		doicon -s 64 "${DISTDIR}"/${PN}.png
		make_desktop_entry ${PN}
	fi
	use doc && dohtml -r docs/online/*
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

