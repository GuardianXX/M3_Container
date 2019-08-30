#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="openssl-1.1.1c"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://www.openssl.org/source/${PKG_ARCHIVE_FILE}"

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
    CROSS_COMPILE="${M3_CROSS_COMPILE}" \
    ./Configure linux-armv4 \
                -no-err \
                -no-camellia \
                -no-seed \
                -no-hw \
                -no-ssl2 \
                -no-ssl3 \
                --prefix="${STAGING_DIR}" \
                shared

    if [ $? -ne 0 ]; then
        exit_failure "failed to configure ${PKG_DIR}"
    else
        cd "Configurations"
        sed 's/ -O3 / $(CFLAGS) /' -i unix-Makefile.tmpl
        cd
        cd "${PKG_BUILD_DIR}"
        make CFLAGS="${M3_CFLAGS} ${M3_LDFLAGS}" depend || exit_failure "failed to configure ${PKG_DIR}"
    fi
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    # do not make parallel builds
    make AR="${AR} r" \
         RANLIB="${RANLIB}" \
         CFLAGS="${M3_CFLAGS} ${M3_LDFLAGS}" \
         V=1 || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" \
         AR="${AR} r" \
         RANLIB="${RANLIB}" \
         CFLAGS="${M3_CFLAGS} ${M3_LDFLAGS}" \
         install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" \
        AR="${AR} r" \
        RANLIB="${RANLIB}" \
        CFLAGS="${M3_CFLAGS} ${M3_LDFLAGS}" \
        install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
