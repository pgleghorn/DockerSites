#!/bin/sh -ax

echo rss
sleep 5

unzip -q -jd /tmp /kits/p17157502_111180_Generic.zip WCS_SatelliteServer_11.1.1.8.0/WCS_SatelliteServer.zip
cd /tmp
unzip WCS_SatelliteServer.zip
cd SatelliteServer
chmod 755 *.sh

# silent installer choices
mkdir -p $V_RSS_INSTALLDIR/ominstallinfo
cat > $V_RSS_INSTALLDIR/ominstallinfo/silentconfig.ini <<ENDSILENTCONFIG
CSPort=5002
CSHostName=delivery
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
CSInstallDirectory=$V_RSS_INSTALLDIR
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
echo "loadfile=$V_RSS_INSTALLDIR/ominstallinfo/silentconfig.ini" >> install.ini

# tweak to make silent install possible, dont check/use DISPLAY variable
sed -i 's/DISPLAY/NODISPLAY/g' ssInstall.sh

# run
( export NODISPLAY=value; wait.sh $V_RSS_INSTALLDIR/ominstallinfo/install_log.log | ./ssInstall.sh -silent )

# manually copy sites webapp
mkdir -p $V_TOMCAT_INSTALLDIR/webapps/cs
cp $V_RSS_INSTALLDIR/ominstallinfo/app/cs.war $V_TOMCAT_INSTALLDIR/webapps/cs
( cd $V_TOMCAT_INSTALLDIR/webapps/cs; jar xvf cs.war )
