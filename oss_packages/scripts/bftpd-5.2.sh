#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="bftpd"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}-5.2.tar.gz"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://astuteinternet.dl.sourceforge.net/project/bftpd/bftpd/bftpd-5.2/${PKG_ARCHIVE_FILE}"

SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    cd "${PKG_BUILD_DIR}"
    CPPFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
    CC="${M3_CROSS_COMPILE}gcc" \
        ./configure --target=${M3_TARGET} --host=${M3_TARGET} --enable-pam --enable-libz
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    CPPFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
    CC="${M3_CROSS_COMPILE}gcc" \
        make ${M3_MAKEFLAGS} LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp bftpd.conf "${STAGING_DIR}/etc"
    cp bftpd "${STAGING_DIR}/bin"
}

. ${HELPERSDIR}/call_functions.sh
