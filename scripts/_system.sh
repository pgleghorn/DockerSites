#!/bin/sh -a

. $V_CONFIG
echo system

hostname $V_HOSTNAME 2>/dev/null
echo "127.0.0.1 $V_HOSTNAME" >> /etc/hosts
chkconfig --level 345 iptables off 2>/dev/null
chkconfig --level 345 ip6tables off 2>/dev/null
/etc/init.d/iptables stop 2>/dev/null
/etc/init.d/ip6tables stop 2>/dev/null
usermod -p '$1$aUtH9gPt$/ykXsfv.w52tq6FlBIQZC0' root # pass1234
useradd -d $V_UNIXUSERHOME -m -p '$1$aUtH9gPt$/ykXsfv.w52tq6FlBIQZC0' $V_UNIXUSER # pass1234
# ensure paths exist
for i in $V_UNIXUSERHOME $V_INSTALLDIR $V_SITES_INSTALLDIR $V_SITES_SHAREDDIR $V_TOMCAT_INSTALLDIR $V_JDK_INSTALLDIR; do
	mkdir -p $i
	chown $V_UNIXUSER:$V_UNIXGROUP $i
done
