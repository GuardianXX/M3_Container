#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="pcre-8.43"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.bz2"

# download link for the sources to be stored in dl directory (use "none" if empty)
PKG_DOWNLOAD="https://ftp.pcre.org/pub/pcre/${PKG_ARCHIVE_FILE}"

SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}/scripts/common_settings.sh"
. "${HELPERSDIR}/functions.sh"
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    cd "${PKG_BUILD_DIR}"
    ./configure CFLAGS="${M3_CFLAGS}" \
                LDFLAGS="${M3_LDFLAGS}" \
                --target=${M3_TARGET} \
                --host=${M3_TARGET} \
                --disable-pcregrep-jit \
                --enable-shared=yes \
                --enable-utf \
                --disable-cpp \
                --prefix="" || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
