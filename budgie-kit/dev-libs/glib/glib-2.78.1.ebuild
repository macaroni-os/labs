# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_REQ_USE="xml(+)"
PYTHON_COMPAT=( python3+ )

inherit gnome3 linux-info meson python-any-r1 toolchain-funcs xdg

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2.1+"
SLOT="2"
IUSE="dbus debug +elf gtk-doc +mime selinux static-libs sysprof systemtap utils xattr"
SRC_URI="https://github.com/GNOME/glib/tarball/21624e78f013ee8706483086e3086076d08fe242 -> glib-2.78.1-21624e7.tar.gz"
KEYWORDS="*"

RDEPEND="
	!<dev-util/gdbus-codegen-${PV}
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	>=dev-libs/libpcre2-10.32:0=[${MULTILIB_USEDEP},unicode(+),static-libs?]
	>=dev-libs/libffi-3.0.13-r1:=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	>=virtual/libintl-0-r2[${MULTILIB_USEDEP}]
	kernel_linux? ( >=sys-apps/util-linux-2.23[${MULTILIB_USEDEP}] )
	selinux? ( >=sys-libs/libselinux-2.2.2-r5[${MULTILIB_USEDEP}] )
	xattr? ( !elibc_glibc? ( >=sys-apps/attr-2.4.47-r1[${MULTILIB_USEDEP}] ) )
	elf? ( virtual/libelf:0= )
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
# libxml2 used for optional tests that get automatically skipped
BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.8
	gtk-doc? ( >=dev-util/gtk-doc-1.33
		app-text/docbook-xml-dtd:4.2
		app-text/docbook-xml-dtd:4.5 )
	systemtap? ( >=dev-util/systemtap-1.3 )
	${PYTHON_DEPS}
	virtual/pkgconfig
"
PDEPEND="
	dbus? ( gnome-base/dconf )
	mime? ( x11-misc/shared-mime-info )
"

# shared-mime-info needed for gio/xdgmime, bug #409481
# dconf is needed to be able to save settings, bug #498436

pkg_setup() {
	if use kernel_linux ; then
		CONFIG_CHECK="~INOTIFY_USER"
		linux-info_pkg_setup
	fi
	python-any-r1_pkg_setup
}

src_prepare() {
	# Don't build tests, also prevents extra deps
	sed -i -e '/subdir.*tests/d' {.,gio,glib}/meson.build || die

	# Don't build fuzzing binaries - not used
	sed -i -e '/subdir.*fuzzing/d' meson.build || die

	# gdbus-codegen is a separate package
	sed -i -e "s/install : true/install : false/" \
		-i -e "s/install_dir : get_option('bindir')/install_dir : '' /" \
		-i -e "s/install_dir : codegen_dir/install_dir : '' /" gio/gdbus-2.0/codegen/meson.build
	sed -i -e "s/[, ]*'gdbus-codegen.*'[,]*//" docs/reference/gio/meson.build


	sed -i -e "s/'python3'/'python'/" meson.build

	# Same kind of meson-0.50 issue with some installed-tests files; will likely be fixed upstream soon
	sed -i -e '/install_dir/d' gio/tests/meson.build || die

	cat > "${T}/glib-test-ld-wrapper" <<-EOF
		#!/usr/bin/env sh
		exec \${LD:-ld} "\$@"
	EOF
	chmod a+x "${T}/glib-test-ld-wrapper" || die
	sed -i -e "s|'ld'|'${T}/glib-test-ld-wrapper'|g" gio/tests/meson.build || die

	# make default sane for us
	if use prefix ; then
		sed -i -e "s:/usr/local:${EPREFIX}/usr:" gio/xdgmime/xdgmime.c || die
		# bug #308609, without path, bug #314057
		export PERL=perl
	fi

	# Tarball doesn't come with gtk-doc.make and we can't unconditionally depend on dev-util/gtk-doc due
	# to circular deps during bootstramp. If actually not building gtk-doc, an almost empty file will do
	# fine as well - this is also what upstream autogen.sh does if gtkdocize is not found. If gtk-doc is
	# installed, eautoreconf will call gtkdocize, which overwrites the empty gtk-doc.make with a full copy.
	cat > gtk-doc.make << EOF
EXTRA_DIST =
CLEANFILES =
EOF

}


src_configure() {
	# Avoid circular depend with dev-util/pkgconfig and
	# native builds (cross-compiles won't need pkg-config
	# in the target ROOT to work here)
	if ! tc-is-cross-compiler && ! $(tc-getPKG_CONFIG) --version >& /dev/null; then
		if has_version sys-apps/dbus; then
			export DBUS1_CFLAGS="-I/usr/include/dbus-1.0 -I/usr/$(get_libdir)/dbus-1.0/include"
			export DBUS1_LIBS="-ldbus-1"
		fi
		export LIBFFI_CFLAGS="-I$(echo /usr/$(get_libdir)/libffi-*/include)"
		export LIBFFI_LIBS="-lffi"
		export PCRE_CFLAGS=" " # test -n "$PCRE_CFLAGS" needs to pass
		export PCRE_LIBS="-lpcre"
	fi

	local emesonargs=(
		-Dc_args="${CFLAGS}"
		--buildtype $(usex debug debug plain)
		-Ddefault_library=$(usex static-libs both shared)
		-Druntime_dir="${EPREFIX}"/run
		$(meson_feature selinux)
		$(meson_use xattr)
		-Dlibmount=$(usex kernel_linux enabled disabled)
		-Dman=true
		$(meson_use systemtap dtrace)
		$(meson_use systemtap)
		$(meson_feature sysprof)
		$(meson_native_use_bool gtk-doc gtk_doc)
		-Dinstalled_tests=false
		-Dnls=enabled
		-Doss_fuzz=disabled
		$(meson_native_use_feature elf libelf)
		-Dmultiarch=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install completiondir="$(get_bashcompdir)"
	keepdir /usr/$(get_libdir)/gio/modules
	einstalldocs

	# Do not install charset.alias even if generated, leave it to libiconv
	rm -f "${ED}/usr/$(get_libdir)/charset.alias"

	# Don't install gdb python macros, bug 291328
	rm -rf "${ED}/usr/share/gdb/" "${ED}/usr/share/glib-2.0/gdb/"

	# Completely useless with or without USE static-libs, people need to use pkg-config
	find "${ED}" -name '*.la' -delete || die
}

pkg_preinst() {
	gnome3_pkg_preinst

	# Make gschemas.compiled belong to glib alone
	local cache="usr/share/glib-2.0/schemas/gschemas.compiled"

	if [[ -e ${EROOT}${cache} ]]; then
		cp "${EROOT}"${cache} "${ED}"/${cache} || die
	else
		touch "${ED}"/${cache} || die
	fi

	if ! tc-is-cross-compiler ; then
		# Make giomodule.cache belong to glib alone
		local cache="usr/$(get_libdir)/gio/modules/giomodule.cache"

		if [[ -e ${EROOT}${cache} ]]; then
			cp "${EROOT}"${cache} "${ED}"/${cache} || die
		else
			touch "${ED}"/${cache} || die
		fi
	fi
}

pkg_postinst() {
	# force (re)generation of gschemas.compiled
	GNOME3_ECLASS_GLIB_SCHEMAS="force"

	gnome3_pkg_postinst
}

pkg_postrm() {
	gnome3_pkg_postrm

	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		rm -f "${EROOT}"usr/$(get_libdir)/gio/modules/giomodule.cache
		rm -f "${EROOT}"usr/share/glib-2.0/schemas/gschemas.compiled
	fi
}
