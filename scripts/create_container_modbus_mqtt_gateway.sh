#!/bin/sh

DESCRIPTION="Contenedor con integración de MQTT en lectura de datos vía ModBus con registro de datos"
CONTAINER_NAME="Contenedor_ModBus_MQTT_R"
ROOTFS_LIST="modbus_mqtt_gateway.txt"

PACKAGES="${PACKAGES} Linux-PAM-1.3.1.sh"
PACKAGES="${PACKAGES} busybox-1.30.1.sh"
PACKAGES="${PACKAGES} finit-1.10.sh"
PACKAGES="${PACKAGES} zlib-1.2.11.sh"
PACKAGES="${PACKAGES} dropbear-2019.78.sh"
PACKAGES="${PACKAGES} timezone2019b.sh"
PACKAGES="${PACKAGES} mcip.sh"
PACKAGES="${PACKAGES} mcip-tool-v2.sh"
PACKAGES="${PACKAGES} pcre-8.43.sh"
PACKAGES="${PACKAGES} metalog-20181125.sh"
PACKAGES="${PACKAGES} openssl-1.0.2s.sh"
PACKAGES="${PACKAGES} libxml2-2.9.9.sh"
PACKAGES="${PACKAGES} sqlite-src-3290000.sh"
PACKAGES="${PACKAGES} gdbm-1.18.1.sh"
PACKAGES="${PACKAGES} lighttpd-1.4.54.sh"
PACKAGES="${PACKAGES} web_interface_modbus_to_mqtt_gateway-1.0.sh"
PACKAGES="${PACKAGES} app_handler-1.0.sh"
PACKAGES="${PACKAGES} c-ares-1.14.0.sh"
PACKAGES="${PACKAGES} libmodbus-3.1.6.sh"
PACKAGES="${PACKAGES} mosquitto-1.6.4.sh"
PACKAGES="${PACKAGES} modbus_to_mqtt_gateway-1.0.sh"

SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)
. ${TOPDIR}/scripts/common_settings.sh
. ${TOPDIR}/scripts/helpers.sh

echo " "
echo "###################################################################################################"
echo " This creates a container with a modbus to MQTT gateway in it."
echo " Within the container will start an SSH server for logins. Both user name and password is \"root\"."
echo "###################################################################################################"
echo " "
echo "It is necessary to build these Open Source projects in this order:"
for PACKAGE in ${PACKAGES} ; do echo "- ${PACKAGE}"; done
echo " "
echo "These packages only have to be compiled once. After that you can package the container yourself with"
echo " # ./scripts/mk_container.sh -n ${CONTAINER_NAME} -l ${ROOTFS_LIST}"
echo " "
echo "Continue? <y/n>"

read text
! [ "${text}" = "y" -o "${text}" = "yes" ] && exit 0

# compile the needed packages
for PACKAGE in ${PACKAGES} ; do
    echo ""
    echo "*************************************************************************************"
    echo "* downloading, checking, configuring, compiling and installing ${PACKAGE%.sh}"
    echo "*************************************************************************************"
    echo ""
    ${OSS_PACKAGES_SCRIPTS}/${PACKAGE} all || exit
done

# package container
echo ""
echo "*************************************************************************************"
echo "* Packaging the container"
echo "*************************************************************************************"
echo ""
${TOPDIR}/scripts/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -d "${DESCRIPTION}" -v "1.0"
