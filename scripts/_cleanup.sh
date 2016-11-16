#!/bin/sh

echo ""
echo "***"
echo "*** cleanup"
echo "***"
echo ""

sudo -i -u $V_UNIXUSER sh -c "shutdown.sh -force"
rm -rf $V_TOMCAT_INSTALLDIR/temp
