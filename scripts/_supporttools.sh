#!/bin/sh

[ ! -f /kits/p22093196_111180_Generic.zip ] && exit

echo supporttools
# unpack
unzip -q -d /tmp/supporttools /kits/p22093196_111180_Generic.zip

# run
java -cp "$V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/lib/*:$V_TOMCAT_INSTALLDIR/lib/*" COM.FutureTense.Apps.CatalogMover -p password -u ContentServer -b http://$V_HOSTNAME:$V_PORT/cs/CatalogManager -x import_all -d /tmp/supporttools
