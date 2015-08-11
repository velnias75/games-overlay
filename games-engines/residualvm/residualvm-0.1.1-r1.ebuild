# Copyright 2014 Julian Ospald <hasufell@posteo.de>
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs multilib gnome2-utils

DESCRIPTION="A cross-platform 3D game interpreter for play LucasArts' LUA-based 3D adventures"
HOMEPAGE="http://www.residualvm.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-sources.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# TODO: fix dynamic plugin support
# games crash without media-libs/libsdl[alsa]
RDEPEND="
	media-libs/alsa-lib
	media-libs/freetype:2
	media-libs/libsdl[X,sound,alsa,joystick,opengl,video]
	sys-libs/zlib
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"

src_configure() {
	# not an autotools script
	# most configure options currently do nothing, recheck on version bump !!!
	# disable explicitly, otherwise we get unneeded linkage (some copy-paste build system)
	./configure \
		--disable-debug \
		--enable-all-engines \
		--backend=sdl \
		--enable-release-mode \
		--disable-tremor \
		--disable-sparkle \
		--prefix="/usr" \
		--datadir="/usr/share/${PN}" \
		--libdir="/usr/$(get_libdir)" \
		--docdir="/usr/share/doc/${PF}" \
		--disable-libunity \
		--disable-faad \
		--disable-flac \
		--disable-fluidsynth \
		--disable-mad \
		--disable-translation \
		--disable-vorbis \
		--enable-zlib \
		|| die "configure failed"
}

src_compile() {
	emake \
		VERBOSE_BUILD=1 \
		AR="$(tc-getAR) cru" \
		RANLIB=$(tc-getRANLIB)
}

src_install() {
	dobin residualvm

	insinto /usr/share/${PN}
	doins gui/themes/modern.zip dists/engine-data/residualvm-grim-patch.lab

	doicon -s scalable icons/${PN}.svg
	doicon -s 256 icons/${PN}.png
	domenu dists/${PN}.desktop

	doman dists/${PN}.6
	dodoc AUTHORS README KNOWN_BUGS TODO
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

