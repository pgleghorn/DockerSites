#!/bin/sh

echo "\n***\n*** hsqldb \n***\n\n"

unzip -q -jd $V_TOMCAT_INSTALLDIR/lib /kits/hsqldb_1_8_0_10.zip hsqldb/lib/hsqldb.jar
chown $V_UNIXUSER:$V_UNIXGROUP $V_TOMCAT_INSTALLDIR/lib/hsqldb.jar
