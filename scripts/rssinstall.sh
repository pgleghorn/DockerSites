#!/bin/sh -a

. $V_CONFIG
echo "Adding $V_SCRIPTS to PATH"
echo "export PATH=$V_SCRIPTS:\$PATH" >> $V_UNIXUSERHOME/.bash_profile

. $V_UNIXUSERHOME/.bash_profile

$V_SCRIPTS/_java.sh
$V_SCRIPTS/_tomcat.sh

. $V_UNIXUSERHOME/.bash_profile

$V_SCRIPTS/_rss.sh
$V_SCRIPTS/_cleanup.sh
