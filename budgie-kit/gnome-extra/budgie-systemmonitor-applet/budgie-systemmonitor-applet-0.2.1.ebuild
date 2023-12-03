# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION="0.48"

inherit meson vala gnome2-utils xdg

DESCRIPTION="System Monitor that can help you track your cpu, ram, swap, network and uptime. Made for Budgie Desktop."
HOMEPAGE="https://github.com/prateekmedia/budgie-systemmonitor-applet"

SRC_URI="https://github.com/prateekmedia/budgie-systemmonitor-applet/tarball/09a699fb5f2fbf7f04afad5602b646b6f5d39f77 -> budgie-systemmonitor-applet-0.2.1-09a699f.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

DEPEND="
	>=gnome-extra/budgie-desktop-10.6.4
	gnome-base/libgtop
	dev-libs/libgee
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

	elog "In order for the applet to appear after installation without relogging it is recommended to run the following as your current logged in user:"
	elog "  budgie-panel --replace &"
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update

	elog "In order for the applet to be removed from the budgie-settings applets without relogging it is recommended to run the following as your current logged in user in budgie:"
	elog "  budgie-panel --replace &"
}