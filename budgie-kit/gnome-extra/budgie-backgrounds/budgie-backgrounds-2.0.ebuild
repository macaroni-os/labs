# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION="0.48"

inherit meson vala gnome2-utils xdg

DESCRIPTION="Budgie Desktop default backgrounds"
HOMEPAGE="https://github.com/BuddiesOfBudgie/${PN}"

SRC_URI="https://github.com/BuddiesOfBudgie/budgie-backgrounds/tarball/66a70ff03a33f17fde4a22b48e7eefe0a8a4c6ec -> budgie-backgrounds-2.0-66a70ff.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="*"

DEPEND="
	>=gnome-extra/budgie-desktop-10.7
	media-gfx/jhead
	media-gfx/imagemagick[jpeg]
	"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/meson
	$(vala_depend)
"

src_prepare() {
	vala_setup
	default
}

src_configure() {
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}