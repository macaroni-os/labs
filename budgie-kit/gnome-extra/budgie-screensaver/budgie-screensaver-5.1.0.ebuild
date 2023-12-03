# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson gnome2-utils xdg

DESCRIPTION="Budgie Screensaver is a fork of gnome-screensaver intended for use with Budgie Desktop and is similar in purpose to other screensavers such as MATE Screensaver."
HOMEPAGE="https://github.com/BuddiesOfBudgie/budgie-screensaver"

SRC_URI="https://github.com/BuddiesOfBudgie/budgie-screensaver/tarball/80bcedde9fc6f118910156a40b010fa684d9f072 -> budgie-screensaver-5.1.0-80bcedd.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="*"
IUSE="systemd +locking +xtools"

DEPEND="
	>=dev-libs/glib-2.64.0:=
	gnome-base/gnome-desktop:3
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.1.91:3[X]
	dev-libs/dbus-glib
	sys-libs/pam
	systemd? ( >=sys-apps/systemd-209:0= )
	xtools? ( x11-libs/libXxf86vm )
"
RDEPEND="
	${DEPEND}
	>=gnome-base/libgnomekbd-3
"
BDEPEND="dev-util/meson"

src_configure() {
	local emesonargs=(
		$(meson_use systemd with-systemd)
		-Dno-locking=$(usex locking false true)
		$(meson_use xtools with-xf86gamma-ext)
		-Dwith-console-kit=false
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