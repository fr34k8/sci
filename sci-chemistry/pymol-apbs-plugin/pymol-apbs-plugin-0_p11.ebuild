# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit python

MY_PV="${PV##*_p}"

DESCRIPTION="APBS plugin for pymol"
HOMEPAGE="http://sourceforge.net/projects/pymolapbsplugin/"
SRC_URI="http://pymolapbsplugin.svn.sourceforge.net/viewvc/pymolapbsplugin/trunk/src/apbsplugin.py?revision=${MY_PV} -> ${P}.py"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="pymol"
IUSE=""

RDEPEND="
	sci-chemistry/apbs
	sci-chemistry/pdb2pqr
	sci-chemistry/pymol[-apbs]"
DEPEND="${RDEPEND}"

src_unpack() {
	cp "${DISTDIR}"/${P}.py "${WORKDIR}"/
}

src_install() {
	sed \
		-e "s:^APBS_BINARY_LOCATION.*:APBS_BINARY_LOCATION = \"${EPREFIX}/usr/bin/apbs\":g" \
		-e "s:^APBS_PSIZE_LOCATION.*:APBS_PSIZE_LOCATION = \"$(python_get_sitedir)/pdb2pqr/src/\":g" \
		-e "s:^APBS_PDB2PQR_LOCATION.*:APBS_PDB2PQR_LOCATION = \"$(python_get_sitedir)/pdb2pqr/\":g" \
		-e "s:^TEMPORARY_FILE_DIR.*:TEMPORARY_FILE_DIR = \"./\":g" \
		-i ${P}.py

	insinto $(python_get_sitedir)/pmg_tk/startup/
	newins ${P}.py apbs_tools.py || die
}

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/pmg_tk/startup/apbs_tools.py
}

pkg_postrm() {
	python_mod_cleanup $(python_get_sitedir)/pmg_tk/startup/apbs_tools.py
}
