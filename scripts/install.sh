#!/bin/sh -a

. /vagrant/config.sh
/vagrant/scripts/_system.sh
/vagrant/scripts/_java.sh
/vagrant/scripts/_tomcat.sh
/vagrant/scripts/_hsqldb.sh
/vagrant/scripts/_sites.sh
/vagrant/scripts/_supporttools.sh
/vagrant/scripts/_tweaks.sh
/vagrant/scripts/_cleanup.sh
. ~$V_UNIXUSER/.bash_profile
