# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg-utils vala

MY_PN="AppStream"
KEYWORDS="*"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="https://github.com/ximion/appstream/tarball/4be36d5f4a6bc401efc84cd6e2d390a59c304115 -> appstream-1.0.0-4be36d5.tar.gz"

DESCRIPTION="Cross-distro effort for providing metadata for software in the Linux ecosystem"
HOMEPAGE="https://www.freedesktop.org/wiki/Distributions/AppStream/"

LICENSE="LGPL-2.1+ GPL-2+"
SLOT="0"
IUSE="apt doc +introspection qt5 vala"

RDEPEND="
	>=dev-libs/glib-2.62:2
	dev-libs/libxml2:2
	>=dev-libs/libxmlb-0.3.6:=
	dev-libs/libyaml
	dev-libs/snowball-stemmer:=
	>=net-misc/curl-7.62
	introspection? ( dev-libs/gobject-introspection )
	qt5? ( dev-qt/qtcore:5 )
"
DEPEND="${RDEPEND}
"
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxslt
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	doc? ( app-text/docbook-xml-dtd:4.5 )
	vala? ( dev-lang/vala )
"

src_prepare() {
	default
	sed -e "/^as_doc_target_dir/s/appstream/${PF}/" -i docs/meson.build || die
	sed -e "/^subdir.*tests/s/^/#DONT /" -i {,qt/}meson.build || die # bug 675944

	if use vala; then
		vala_setup
	fi
}

src_configure() {
	xdg_environment_reset

	local emesonargs=(
		-Dapidocs=false
		-Ddocs=false
		-Dcompose=false
		-Dmaintainer=false
		-Dstatic-analysis=false
		-Dstemming=true
		-Dvapi=$(usex vala true false)
		-Dapt-support=$(usex apt true false)
		-Dinstall-docs=$(usex doc true false)
		-Dgir=$(usex introspection true false)
		-Dqt=$(usex qt5 true false)
	)

	meson_src_configure
}