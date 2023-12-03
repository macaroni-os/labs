# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION="0.48"

inherit gnome3 meson vala

DESCRIPTION="Add an analogue clock to the Budgie Panel. Made for Budgie Desktop."
SRC_URI="https://github.com/samlane-ma/analogue-clock-applet/tarball/5e6f27030fcc50c69975a7572faee108c0279fc6 -> analogue-clock-applet-2.0-5e6f270.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

DEPEND=">=gnome-extra/budgie-desktop-10.6.4"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/meson
	$(vala_depend)
"

src_unpack() {
	default
	mv ${WORKDIR}/samlane-ma-${PV} ${S}
}

src_prepare() {
	vala_setup
	default
}

pkg_postinst() {
	gnome3_schemas_update

	elog "In order for the applet to appear after installation without relogging it is recommended to run the following as your current logged in user:"
	elog "  budgie-panel --replace &"
}

pkg_postrm() {
	gnome3_schemas_update

	elog "In order for the applet to be removed from the budgie-settings applets without relogging it is recommended to run the following as your current logged in user in budgie:"
	elog "  budgie-panel --replace &"
}