#!/bin/sh -x

. /vagrant/config.sh
. $HOME/.bash_profile
echo patch11
mkdir /tmp/p11
cd /tmp/p11
unzip -q -d . /kits/p21494888_111180_Generic.zip
chown -R $V_UNIXUSER:$V_UNIXGROUP /tmp/p11
cd patch
 
# 1 cas war
rm -rf $V_TOMCAT_INSTALLDIR/webapps/cas
cp cas_upgrade/cas.war $V_TOMCAT_INSTALLDIR/webapps
( cd $V_TOMCAT_INSTALLDIR/webapps; jar xf cas.war )
# 2 cas webapp backup
# 3 new cas config
mkdir $V_SITES_INSTALLDIR/bin_backup_pre_p11
cp -r $V_SITES_INSTALLDIR/bin/* $V_SITES_INSTALLDIR/bin_backup_pre_p11
cp -r cas_upgrade/config/cas/* $V_SITES_INSTALLDIR/bin
# 4 tweak cas config
bindir=$V_SITES_INSTALLDIR/bin
for i in $bindir/cas.properties $bindir/customBeans.xml $bindir/deployerConfigContext.xml $bindir/host.properties $bindir/jbossTicketCacheReplicationConfig.xml $bindir/log4j.xml $bindir/cas-spring-configuration/customDefaultWEMSSObeans.xml; do
  echo correcting cas configuration in $i
  /vagrant/scripts/diffsed "s/@CSConnectPrefix@/http/g" $i
  /vagrant/scripts/diffsed "s/@hostname@/$V_HOSTNAME/g" $i
  /vagrant/scripts/diffsed "s/@portnumber@/$V_PORT/g" $i
  /vagrant/scripts/diffsed "s/@context-path@/cs/g" $i
  /vagrant/scripts/diffsed "s/@unique_id@/$V_HOSTNAME-$V_PORT-uniqueid/g" $i
  /vagrant/scripts/diffsed "s/@CASHostNameActual@/$V_HOSTNAME/g" $i
  /vagrant/scripts/diffsed "s/@cas.log@/\/tmp\/cas.log/g" $i
done
# 5 cas jboss cluster
/vagrant/scripts/diffsed "s/48866/45678/g" $V_SITES_INSTALLDIR/bin/jbossTicketCacheReplicationConfig.xml
/vagrant/scripts/diffsed "s/TreeCache-Cluster/$V_HOSTNAME-TreeCache-Cluster/g" $V_SITES_INSTALLDIR/bin/jbossTicketCacheReplicationConfig.xml
# 6 sites webapp
cp -r sites_webapp/* $V_TOMCAT_INSTALLDIR/webapps/cs
# 7 sites satellite.properties
/vagrant/scripts/diffsed "d/^transparent.content-type.pattern=/" $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/classes/satellite.properties
echo "transparent.content-type.pattern=text/.*|.*xml(?!formats).*" >> $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/classes/satellite.properties
# 8 rss webapp
# 9 rss satellite.properties
# 10 sites install
cp -r sites_install/* $V_SITES_INSTALLDIR
# 11 csdt
# 12 assetpublishcallback & dataunpacker
/vagrant/scripts/diffsed "/<beans>/ r /vagrant/scripts/patch11/patch_xml/assetpublishcallback.xml" $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/classes/AdvPub.xml
/vagrant/scripts/diffsed "/<bean id=.DataUnpacker./ r /vagrant/scripts/patch11/patch_xml/dataunpacker.xml" $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/classes/AdvPub.xml
# 13 remove old jars
for i in $V_SITES_INSTALLDIR/Sun/lib $V_SITES_INSTALLDIR/Sun/jws/common/lib $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/lib $V_TOMCAT_INSTALLDIR/webapps/cas/WEB-INF/lib; do
  echo "removing old jars from $i"
  for k in aspectjrt-1.5.3.jar aspectjweaver-1.5.3.jar commons-codec-1.4.jar commons-fileupload-1.2.1.jar commons-io-1.4.jar commons-lang-2.4.jar jaxb-api-2.1.jar jaxb-impl-2.1.12.jar log4j-1.2.16.jar slf4j-api-1.5.8.jar slf4j-jdk14-1.5.8.jar slf4j-api-1.6.1.jar slf4j-jdk14-1.6.1.jar spring-2.5.5.jar spring-2.5.6.jar spring-2.5.6.SEC03.jar xwork-2.0.4.jar; do
    filename=$i/$k
    echo removing $filename
    rm -f $filename
  done
done
# 14 fileupload jar
rm -f $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/lib/commons-fileupload-1.2.1.jar
# 15a shutdown listener, already done
# 15b shutdown hook, already done
# 16 NoAccess, place it after the welcome-file-list element
/vagrant/scripts/diffsed "/<\/welcome-file-list>/ r /vagrant/scripts/patch11/patch_xml/noaccess.xml" $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/web.xml
/vagrant/scripts/diffsed "/<\/welcome-file-list>/ r /vagrant/scripts/patch11/patch_xml/noaccess.xml" $V_TOMCAT_INSTALLDIR/webapps/cas/WEB-INF/web.xml
# 17 ContentSecurityFilter, place the filter as the first filter after the error-page element, and put the filter-mapping after the first filter-mapping
# first cs
##/vagrant/scripts/diffsed "/<\/error-page>/ r /vagrant/scripts/patch11/patch_xml/contentsecurityfilter.xml" $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/web.xml
##/vagrant/scripts/diffsed "0,/<\/filter-mapping>/ s/<\/filter-mapping>/<\/filter-mapping>\nMARKER/" $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/web.xml
##/vagrant/scripts/diffsed "/MARKER/r /vagrant/scripts/patch11/patch_xml/contentsecurityfiltermapping.xml" $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/web.xml
##/vagrant/scripts/diffsed "/MARKER/d" $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/web.xml
# then cas
# TODO - cas has multiple error-page in web.xml - sed -i '/<\/error-page>/ r /vagrant/scripts/patch11/patch_xml/contentsecurityfilter.xml' $V_TOMCAT_INSTALLDIR/webapps/cas/WEB-INF/web.xml
# TODO  sed -i -e '0,/<\/filter-mapping>/ s/<\/filter-mapping>/<\/filter-mapping>\nMARKER/' -e '/MARKER/r scripts/patch11/patch_xml/contentsecurityfiltermapping.xml' $V_TOMCAT_INSTALLDIR/webapps/cas/WEB-INF/web.xml
# TODO  sed -i -e '/MARKER/d' $V_TOMCAT_INSTALLDIR/webapps/cas/WEB-INF/web.xml
# 18 eloqua filter, place the filter as the first filter after the error-page element, and put the filter-mapping after the first filter-mapping
##/vagrant/scripts/diffsed "/<\/error-page>/ r /vagrant/scripts/patch11/patch_xml/eloquafilter.xml" $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/web.xml
##/vagrant/scripts/diffsed "0,/<\/filter-mapping>/ s/<\/filter-mapping>/<\/filter-mapping>\nMARKER/" $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/web.xml
##/vagrant/scripts/diffsed "/MARKER/r /vagrant/scripts/patch11/patch_xml/eloquafiltermapping.xml" $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/web.xml
##/vagrant/scripts/diffsed "/MARKER/d" $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/web.xml
# 19 ckeditor bug
/vagrant/scripts/diffsed "/config.fullPage/ r /vagrant/scripts/patch11/patch_xml/configprotectedsource.js" $V_TOMCAT_INSTALLDIR/webapps/cs/ckeditor/config.js
# 20 ldap caseAware
# 21 reindex
# 22 revisions
echo "cs.deleteExcessRevisionsFromDisk=true" >> $V_SITES_INSTALLDIR/futuretense.ini
# 23 TODO email ssl/tls
# 24 eloqua loggers
echo "log4j.logger.oracle.wcsites.eloquaintegration=INFO" >> $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/classes/log4j.properties
echo "log4j.logger.oracle.wcsites.eloquaintegration.jsp=INFO" >> $V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/classes/log4j.properties
# 25 youtube assets
echo "cs.youtubeapikey=provideYourOwnKey" >> $V_SITES_INSTALLDIR/futuretense.ini

# startup

startup.sh
while ! wget -q -O- http://$V_HOSTNAME:$V_PORT/cs/HelloCS | grep reason=Success; do echo "...starting..." ; sleep 1; done

# 26 patch elements
java -cp "$V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/lib/*:$V_TOMCAT_INSTALLDIR/lib/*" COM.FutureTense.Apps.CatalogMover -p xceladmin -u fwadmin -b http://$V_HOSTNAME:$V_PORT/cs/CatalogManager -x import_all -d /tmp/p11/patch/elements
# 27 eloqua elements
java -cp "$V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/lib/*:$V_TOMCAT_INSTALLDIR/lib/*" COM.FutureTense.Apps.CatalogMover -p xceladmin -u fwadmin -b http://$V_HOSTNAME:$V_PORT/cs/CatalogManager -x import_all -d /tmp/p11/patch/eloqua-integration
# 28 avisports elements
java -cp "$V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/lib/*:$V_TOMCAT_INSTALLDIR/lib/*" COM.FutureTense.Apps.CatalogMover -p xceladmin -u fwadmin -b http://$V_HOSTNAME:$V_PORT/cs/CatalogManager -x import_all -d /tmp/p11/patch/avisports/elements
# other, dojo tree
/vagrant/scripts/diffsed "s/xcelerate.treeType=OMTree/xcelerate.treeType=DojoTree/g" $V_SITES_INSTALLDIR/futuretense_xcel.ini

# shutdown
shutdown.sh -force
