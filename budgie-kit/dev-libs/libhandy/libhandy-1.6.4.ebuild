# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson xdg vala virtualx

DESCRIPTION="Building blocks for modern adaptive GNOME apps"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libhandy/"

LICENSE="LGPL-2.1+"
SLOT="1"
KEYWORDS="*"

SRC_URI="https://github.com/GNOME/libhandy/tarball/c6e1c5171d4c2168e96117aed3a9c44ae340c54d -> libhandy-1.6.4-c6e1c51.tar.gz"

IUSE="examples glade gtk-doc +introspection test +vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"
RDEPEND="
	>=dev-libs/glib-2.44:2
	>=x11-libs/gtk+-3.24.1:3[introspection?]
	glade? ( dev-util/glade:3.10= )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	dev-libs/libxml2:2
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? ( >=dev-util/gi-docgen-2021.1
		app-text/docbook-xml-dtd:4.3 )
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-Dprofiling=false # -pg passing
		$(meson_feature introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use test tests)
		$(meson_use examples)
		$(meson_feature glade glade_catalog)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}