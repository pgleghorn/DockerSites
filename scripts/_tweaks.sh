#!/bin/sh

echo ""
echo "***"
echo "*** tweaks"
echo "***"
echo ""

# sites config
sed -i 's/cs.timeout=.*/cs.timeout=18000/' $V_SITES_INSTALLDIR/futuretense.ini
sed -i 's/advancedUI.enableAssetForms=false/advancedUI.enableAssetForms=true/' $V_SITES_INSTALLDIR/futuretense_xcel.ini

# handy aliases
echo 'alias psme="ps aux | grep $USER"' >> $V_UNIXUSERHOME/.bash_profile
echo "alias logmon=\"tail -n0 -f $V_TOMCAT_INSTALLDIR/logs/* $V_SITES_INSTALLDIR/logs/*\"" >> $V_UNIXUSERHOME/.bash_profile
