# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION="0.48"

inherit meson vala gnome2-utils xdg

DESCRIPTION="This applet hides the title bar from maximized windows and creates a new one inside the panel. Inspired from gnome extension pixel-saver."
HOMEPAGE="https://github.com/ilgarmehmetali/budgie-pixel-saver-applet"

SRC_URI="https://github.com/ilgarmehmetali/budgie-pixel-saver-applet/tarball/01d46180b9574e67d1e22052312a1080308cf4d6 -> budgie-pixel-saver-applet-4.0.0-01d4618.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

DEPEND="
	>=gnome-extra/budgie-desktop-10.6.4
	>=x11-libs/libwnck-3.0
	x11-apps/xprop
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/meson
	$(vala_depend)
"

PATCHES=(
	"${FILESDIR}/fix_post_install_script.patch"
)

src_prepare() {
	cp ${FILESDIR}/meson_post_install.py ${WORKDIR}/${P}/

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

	elog "In order for the applet to appear after installation without relogging it is recommended to run the following as your current logged in user:"
	elog "  budgie-panel --replace &"
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update

	elog "In order for the applet to be removed from the budgie-settings applets without relogging it is recommended to run the following as your current logged in user in budgie:"
	elog "  budgie-panel --replace &"
}