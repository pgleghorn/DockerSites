#!/bin/sh -ax

. /vagrant/config.sh
/vagrant/scripts/_system.sh
/vagrant/scripts/_java.sh
/vagrant/scripts/_tomcat.sh
/vagrant/scripts/_hsqldb.sh
/vagrant/scripts/_sites.sh
[ -f /kits/p22093196_111180_Generic.zip ] && /vagrant/scripts/_supporttools.sh
/vagrant/scripts/patch11/install.sh
/vagrant/scripts/_tweaks.sh
/vagrant/scripts/_cleanup.sh
#/vagrant/scripts/_end.sh
