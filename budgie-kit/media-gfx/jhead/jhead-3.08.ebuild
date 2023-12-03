# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Exif Jpeg camera setting parser and thumbnail remover"
HOMEPAGE="http://www.sentex.net/~mwandel/jhead"
SRC_URI="https://github.com/Matthias-Wandel/jhead/tarball/4d04ac965632e35a65709c7f92a857a749e71811 -> jhead-3.08-4d04ac9.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="*"

PATCHES=(
	"${FILESDIR}/${P}-mkstemp-fix-makefile.patch"
	"${FILESDIR}/${P}-CVE-2021-34055.patch"
)

src_install() {
	dobin ${PN}
	dodoc *.txt
	docinto html
	dodoc *.html
	doman ${PN}.1
	doheader ${PN}.h
	dolib.so lib${PN}.so*
}