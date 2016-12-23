#!/bin/sh -a

echo startupDynamicRss
V_NEW_COMPOSE_HOSTNAME=${1:?new compose hostname}
V_NEW_COMPOSE_PORT=${2:?new compose port}
env | grep V_ | sort
. $V_CONFIG
rename.sh $V_RSS_INSTALLDIR $V_TOMCAT_INSTALLDIR
catalina.sh run
