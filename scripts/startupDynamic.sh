#!/bin/sh -a

echo startupDynamic
V_NEW_COMPOSE_HOSTNAME=${1:?new compose hostname}
V_NEW_COMPOSE_PORT=${2:?new compose port}
. $V_CONFIG
env | grep V_ | sort
$V_SCRIPTS/rename.sh $V_SITES_INSTALLDIR $V_TOMCAT_INSTALLDIR
catalina.sh run
