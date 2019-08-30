#!/bin/sh

DESCRIPTION="A container to demonstrate the mosquitto MQTT broker"
CONTAINER_NAME="container_mosquitto_mqtt_broker"
ROOTFS_LIST="mosquitto_mqtt_broker.txt"

PACKAGES="${PACKAGES} Linux-PAM-1.3.1.sh"
PACKAGES="${PACKAGES} busybox-1.31.0.sh"
PACKAGES="${PACKAGES} finit-1.10.sh"
PACKAGES="${PACKAGES} zlib-1.2.11.sh"
PACKAGES="${PACKAGES} dropbear-2019.78.sh"
PACKAGES="${PACKAGES} timezone2019b.sh"
PACKAGES="${PACKAGES} mcip.sh"
PACKAGES="${PACKAGES} mcip-tool-v2.sh"
PACKAGES="${PACKAGES} pcre-8.43.sh"
PACKAGES="${PACKAGES} metalog-20181125.sh"
PACKAGES="${PACKAGES} openssl-1.1.1c.sh"
PACKAGES="${PACKAGES} libxml2-2.9.9.sh"
PACKAGES="${PACKAGES} sqlite-src-3290000.sh"
PACKAGES="${PACKAGES} gdbm-1.18.1.sh"
PACKAGES="${PACKAGES} lighttpd-1.4.54.sh"
PACKAGES="${PACKAGES} web_interface_mosquitto_mqtt_broker-1.0.sh"
PACKAGES="${PACKAGES} app_handler-1.0.sh"
PACKAGES="${PACKAGES} c-ares-1.14.0.sh"
PACKAGES="${PACKAGES} libmodbus-3.1.6.sh"
PACKAGES="${PACKAGES} mosquitto-1.6.4.sh"

SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)
. ${TOPDIR}/scripts/common_settings.sh
. ${TOPDIR}/scripts/helpers.sh

echo " "
echo "###################################################################################################"
echo " This creates a container with the mosquitto MQTT broker in it."
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

SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)
. ${TOPDIR}/scripts/common_settings.sh

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
