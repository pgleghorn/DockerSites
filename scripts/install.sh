#!/bin/sh -a

. /vagrant/config.sh
/vagrant/scripts/_java.sh
/vagrant/scripts/_tomcat.sh
/vagrant/scripts/_hsqldb.sh

. $V_UNIXUSERHOME/.bash_profile

/vagrant/scripts/_sites.sh
/vagrant/scripts/_supporttools.sh
/vagrant/scripts/_tweaks.sh
/vagrant/scripts/_cleanup.sh
