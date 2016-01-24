#!/bin/sh -x

yum -y install openldap-servers
yum -y install openldap-clients
/etc/init.d/slapd start
chkconfig --level 3 slapd on
