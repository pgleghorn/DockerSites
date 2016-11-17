#!/bin/sh

echo "\n***\n*** cleanup \n***\n\n"

sudo -i -u $V_UNIXUSER sh -c "shutdown.sh -force"
rm -rf $V_TOMCAT_INSTALLDIR/temp
