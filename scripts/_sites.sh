#!/bin/sh

echo sites
sleep 5

# unpack
unzip -q -jd /tmp /kits/ofm_sites_generic_11.1.1.8.0_disk1_1of1.zip WebCenterSites_11.1.1.8.0/WCS_Sites/WCS_Sites.zip
cd /tmp
unzip -q WCS_Sites.zip
cd Sites
chmod 755 *.sh

# re-enable hsqldb db option for tomcat
sed -i '1916i\
<COMBOBOXENTRY TEXT="HSQL Database Engine" HASHVALUE="HSQLDB">\
<\/COMBOBOXENTRY>\
' cscore.xml

# silent installer choices
mkdir -p $V_SITES_INSTALLDIR/ominstallinfo
cat > $V_SITES_INSTALLDIR/ominstallinfo/silentconfig.ini <<ENDSILENTCONFIG
Avisports=true
CASHostNameActual=$V_HOSTNAME
CASHostNameLocal=$V_HOSTNAME
CASHostName=$V_HOSTNAME
CASPortNumber=$V_PORT
CASPortNumberLocal=$V_PORT
CatalogCentre=true
CommerceConnector=false
ContentCentre=true
CSInstallAccountName=ContentServer
CSInstallAccountPassword={AES}57FB2563B615AB6630483ED0132A5BEA
CSInstallAppName=fwadmin
CSInstallAppPassword={AES}88A21D9353F9BDDCD80751A90800F620
CSInstallAppServerPath=$V_TOMCAT_INSTALLDIR
CSInstallAppServerType=tomcat5
CSInstallDatabaseType=HSQLDB
CSInstallDBDSN=csDataSource
CSInstallDirectory=$V_SITES_INSTALLDIR
CSInstallPlatformType=APPSERVER
CSInstallSharedDirectory=$V_SITES_SHAREDDIR
CSInstallType=single
CSInstallWebServerAddress=$V_HOSTNAME
CSInstallWebServerPort=$V_PORT
Development=true
IsWEMInstall=TRUE
LoggerName=org.apache.commons.logging.impl.Log4JLogger
MarketingStudio=true
sCgiPath=/cs/
SSUserName=SatelliteServer
SSUserPassword={AES}57FB2563B615AB6630483ED0132A5BEA
ENDSILENTCONFIG

# installer.ini changes for silent install
sed -i 's/nodisplay=false/nodisplay=true/' install.ini
sed -i '/^loadfile=/d' install.ini
echo "loadfile=$V_SITES_INSTALLDIR/ominstallinfo/silentconfig.ini" >> install.ini

# run
( cd /tmp/Sites; $V_SCRIPTS/wait.sh | ./csInstall.sh -silent )

# fix esapi loading
mkdir -p $V_UNIXUSERHOME/esapi
cp $V_SITES_INSTALLDIR/bin/ESAPI.properties $V_UNIXUSERHOME/esapi
cp $V_SITES_INSTALLDIR/bin/validation.properties $V_UNIXUSERHOME/esapi
