#! /bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="mosquitto-1.6.4"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="mosquitto-1.6.4.tar.gz"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://mosquitto.org/files/source/mosquitto-1.6.4.tar.gz"

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
    true
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"

    export CC="${M3_CROSS_COMPILE}gcc"
    export CXX=$CC
    export CROSS_COMPILE=""
    export CFLAGS="${M3_CFLAGS}  -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS}  -L${STAGING_LIB} -lcrypto -lssl -lcares"

    make WITH_UUID=no "${M3_MAKEFLAGS}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    export CROSS_COMPILE=""
    export STRIP=armv7a-hardfloat-linux-gnueabi-strip
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
