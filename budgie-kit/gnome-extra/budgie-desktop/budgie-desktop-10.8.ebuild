# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION="0.52"

inherit gnome2-utils meson vala xdg

DESCRIPTION="Desktop Environment based on GNOME 3"
HOMEPAGE="https://github.com/BuddiesOfBudgie/"
SRC_URI="https://github.com/BuddiesOfBudgie/budgie-desktop/tarball/1d4f822458fc2efa3673f25d7477fb301eceac73 -> budgie-desktop-10.8-1d4f822.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="gtk-doc +policykit stateless +bluetooth +hibernate"

COMMON_DEPEND="
	>=app-i18n/ibus-1.5.10[vala]
	>=dev-libs/glib-2.66.3:=
	>=dev-libs/libpeas-1.26.0:0=[gtk]
	>=dev-libs/libgee-0.20.0:0.8=
	gnome-base/gnome-desktop:3
	gnome-base/gnome-settings-daemon
	gnome-base/gsettings-desktop-schemas
	>=gnome-base/gnome-menus-3.10.3:3[introspection]
	>=gnome-extra/budgie-screensaver-5.0
	media-libs/clutter:1.0
	media-libs/gstreamer:1.0
	media-libs/libcanberra:=[gtk3]
	>=media-libs/graphene-1.10:=[introspection]
	media-libs/cogl:1.0
	media-sound/pulseaudio
	>=net-wireless/gnome-bluetooth-3.34.0:2=
	>=sys-apps/accountsservice-0.6.55
	sys-apps/util-linux
	>=sys-power/upower-0.99.0:0=
	>=x11-libs/gtk+-3.24.35:3[X,introspection]
	>=x11-libs/libnotify-0.7
	x11-libs/libwnck:3
	x11-libs/libX11:=
	x11-libs/libXcomposite:=
	>=x11-libs/cairo-1.5.10
	x11-wm/mutter:=
	policykit? ( >=sys-auth/polkit-0.105[introspection] )
"

RDEPEND="
	${COMMON_DEPEND}
	>=gnome-base/gnome-control-center-3.26[bluetooth]
	gnome-base/gnome-session
"

BDEPEND="
	$(vala_depend)
	dev-util/intltool
	dev-lang/sassc
	gtk-doc? ( dev-util/gtk-doc )
"

DEPEND="
	${COMMON_DEPEND}
	>=dev-libs/gobject-introspection-1.44.0
"

src_unpack() {
	unpack ${P}.tar.xz
}

src_prepare() {
	sed -i -e "/add_install_script.*meson_post_install\.sh/d" meson.build || die

	vala_setup
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc with-gtk-doc)
		$(meson_use policykit with-polkit)
		$(meson_use stateless with-stateless)
		$(meson_use bluetooth with-bluetooth)
		$(meson_use hibernate with-hibernate)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}