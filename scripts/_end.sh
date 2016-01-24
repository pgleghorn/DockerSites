#!/bin/sh

echo ""
echo "***"
echo "*** install finished"
echo "***"
echo ""

#cat /etc/hosts
#ps -fu $V_UNIXUSER | grep java
#ifconfig -a
#df -h

echo ""
echo "Now add this to your host file (/etc/hosts, or C:\\Windows\\System32\\drivers\\etc\\hosts)"
echo "    $V_IP_ADDRESS $V_HOSTNAME"
echo "then goto http://$V_HOSTNAME:$V_PORT/cs/"
echo
echo "For shell access, login as vagrant user directly with:"
echo "    vagrant ssh"
echo "or any other user via ssh"
echo "    ssh -p $V_VAGRANTSSHPORT <user>@$V_HOSTNAME"
echo "users are:"
echo "    root : pass1234"
echo "    phil : pass1234"
echo "    vagrant : vagrant"
echo 
echo "To start X11, log onto the virtualbox console and then run:"
echo "    /vagrant/scripts/x11.sh"
echo "which installs various rpm groups and runs startx"
