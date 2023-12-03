# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
DISTUTILS_USE_PEP517="flit"
inherit distutils-r1

DESCRIPTION="CSS selectors for Python ElementTree"
HOMEPAGE="None https://pypi.org/project/cssselect2/"
SRC_URI="https://files.pythonhosted.org/packages/e7/fc/326cb6f988905998f09bb54a3f5d98d4462ba119363c0dfad29750d48c09/cssselect2-0.7.0.tar.gz -> cssselect2-0.7.0.tar.gz"

DEPEND=""
RDEPEND="
	dev-python/tinycss2[${PYTHON_USEDEP}]
	dev-python/webencodings[${PYTHON_USEDEP}]"
IUSE=""
SLOT="0"
LICENSE="BSD"
KEYWORDS="*"
S="${WORKDIR}/cssselect2-0.7.0"