# Distributed under the terms of the GNU General Public License v2

EAPI=7

BUILD_DIR="${WORKDIR}/${P}-build"

inherit meson vala xdg

DESCRIPTION="Elementary OS library that extends GTK+"
HOMEPAGE="https://github.com/elementary/granite"
#SRC_URI="https://github.com/elementary/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/elementary/granite/tarball/949703f8649013695c6d32eb84a6b541ac0da4db -> granite-7.4.0-949703f.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="*"

BDEPEND="
	$(vala_depend)
	virtual/pkgconfig
"
DEPEND="
	>=dev-libs/glib-2.50:2
	>=x11-libs/gtk+-3.22:3[introspection]
	dev-libs/libgee:0.8[introspection]
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	# docs disabled due to: https://github.com/elementary/granite/issues/482
	local emesonargs=(
		-Ddocumentation=false
	)
	meson_src_configure
}