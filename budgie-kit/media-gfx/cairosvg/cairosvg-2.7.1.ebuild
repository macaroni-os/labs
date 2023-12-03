# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
DISTUTILS_USE_PEP517="setuptools"
inherit distutils-r1

DESCRIPTION="A Simple SVG Converter based on Cairo"
HOMEPAGE="https://courtbouillon.org/cairosvg https://pypi.org/project/CairoSVG/"
SRC_URI="https://files.pythonhosted.org/packages/d5/e6/ec5900b724e3c44af7f6f51f719919137284e5da4aabe96508baec8a1b40/CairoSVG-2.7.1.tar.gz -> CairoSVG-2.7.1.tar.gz"

DEPEND=""
RDEPEND="
	dev-python/cairocffi[${PYTHON_USEDEP}]
	dev-python/cssselect2[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/tinycss2[${PYTHON_USEDEP}]"
IUSE=""
SLOT="0"
LICENSE=""
KEYWORDS="*"
S="${WORKDIR}/cairosvg-2.7.1"