#!/bin/sh

echo "\n***\n*** setup system \n***\n\n"

hostname $V_HOSTNAME
ipaddr=$V_IP_ADDRESS
echo "127.0.0.1 $V_HOSTNAME" >> /etc/hosts
chkconfig --level 345 iptables off
chkconfig --level 345 ip6tables off
/etc/init.d/iptables stop
/etc/init.d/ip6tables stop
usermod -p '$1$aUtH9gPt$/ykXsfv.w52tq6FlBIQZC0' root # pass1234
useradd -d $V_UNIXUSERHOME -m -p '$1$aUtH9gPt$/ykXsfv.w52tq6FlBIQZC0' $V_UNIXUSER # pass1234
