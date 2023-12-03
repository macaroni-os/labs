# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION="0.48"

inherit meson vala gnome2-utils xdg

DESCRIPTION="This applet allows you to controll screen brightness. Made for Budgie Desktop."
HOMEPAGE="https://github.com/Azania/${PN}"
SRC_URI="https://github.com/Azania/budgie-brightness-control-applet/tarball/e5375c3ae13dd9f8ab67d667210ccf520bc4f8bc -> budgie-brightness-control-applet-0.3-e5375c3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

DEPEND=">=gnome-extra/budgie-desktop-10"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/meson $(vala_depend)"

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

	elog "In order for the applet to appear after installation without relogging it is recommended to run the following  as your current logged in user:"
	elog "  budgie-panel --replace &"
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update

	elog "In order for the applet to be removed from the budgie-settings applets without relogging it is recommended to run the following as your current logged in user in budgie:"
	elog "  budgie-panel --replace &"
}