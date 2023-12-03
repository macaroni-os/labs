# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
DISTUTILS_USE_PEP517="setuptools"
inherit distutils-r1

DESCRIPTION="A Python library to create SVG drawings."
HOMEPAGE="http://github.com/mozman/svgwrite.git https://pypi.org/project/svgwrite/"
SRC_URI="https://files.pythonhosted.org/packages/16/c1/263d4e93b543390d86d8eb4fc23d9ce8a8d6efd146f9427364109004fa9b/svgwrite-1.4.3.zip -> svgwrite-1.4.3.zip"

DEPEND=""
IUSE=""
SLOT="0"
LICENSE="MIT"
KEYWORDS="*"
S="${WORKDIR}/svgwrite-1.4.3"