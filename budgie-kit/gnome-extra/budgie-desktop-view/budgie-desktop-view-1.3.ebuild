# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION="0.53"

inherit meson vala gnome2-utils xdg

DESCRIPTION="Basic desktop icons/managemlent for Budgie Desktop."
HOMEPAGE="https://github.com/BuddiesOfBudgie/budgie-desktop-view"

SRc_URI="https://github.com/BuddiesOfBudgie/budgie-desktop-view/tarball/e22d034d50352c9609238236bdf7773c610a47fe -> budgie-desktop-view-1.3-e22d034.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

IUSE="stateless"

DEPEND=">=gnome-extra/budgie-desktop-10.7"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/meson
	$(vala_depend)
"

src_prepare() {
	sed -i -e \
	's|run_command('git', ['rev-parse', 'HEAD'], check: true)|run_command('git', ['rev-parse', 'HEAD'], check: false)|g' \
		meson.build || die
	vala_setup
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use stateless with-stateless)
	)

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