#!/bin/sh

echo ""
echo "***"
echo "*** setup hsqldb"
echo "***"
echo ""

unzip -q -jd $V_TOMCAT_INSTALLDIR/lib /kits/hsqldb_1_8_0_10.zip hsqldb/lib/hsqldb.jar
chown $V_UNIXUSER:$V_UNIXGROUP $V_TOMCAT_INSTALLDIR/lib/hsqldb.jar
