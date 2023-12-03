# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta ebuild for Budgie Desktop with all official releases of needed packages"
HOMEPAGE="https://blog.buddiesofbudgie.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="*"
IUSE="minimal all-packages"
REQUIRED_USE="?? ( minimal all-packages )"

RDEPEND="
	>=gnome-extra/budgie-screensaver-5.1.0
	>=gnome-extra/budgie-desktop-10.7.1
	>=gnome-extra/budgie-desktop-view-1.2.1
	>=gnome-extra/budgie-control-center-1.2.0
	!minimal? (
		>=gnome-extra/budgie-extras-1.6.0
		>=gnome-extra/budgie-backgrounds-1.0
	)
	all-packages? (
		>=gnome-extra/budgie-analogue-clock-applet-2.0
		>=gnome-extra/budgie-brightness-control-applet-0.3
		>=gnome-extra/budgie-calendar-applet-5.3
		>=gnome-extra/budgie-clipboard-applet-1.1.0
		>=gnome-extra/budgie-haste-applet-0.3.0
		>=gnome-extra/budgie-pixel-saver-applet-4.0.0
		>=gnome-extra/budgie-screenshot-applet-0.4.3
		>=gnome-extra/budgie-systemmonitor-applet-0.2.1
		>=gnome-extra/budgie-extras-1.6.0[budgie_extras_applets_all]
	)
"
