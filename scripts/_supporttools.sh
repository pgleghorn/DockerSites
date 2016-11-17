#!/bin/sh

echo "\n***\n*** support tools \n***\n\n"

# unpack
unzip -q -d /tmp/supporttools /kits/p22093196_111180_Generic.zip
chown -R $V_UNIXUSER:$V_UNIXGROUP /tmp/supporttools

# run
sudo -i -u $V_UNIXUSER sh -c "set -a; . /vagrant/config.sh; java -cp \"$V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/lib/*:$V_TOMCAT_INSTALLDIR/lib/*\" COM.FutureTense.Apps.CatalogMover -p password -u ContentServer -b http://$V_HOSTNAME:$V_PORT/cs/CatalogManager -x import_all -d /tmp/supporttools"
