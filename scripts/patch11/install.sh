#!/bin/sh -a

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
mkdir $V_TOMCAT_INSTALLDIR/webapps/cas
cp cas_upgrade/cas.war $V_TOMCAT_INSTALLDIR/webapps/cas
( cd $V_TOMCAT_INSTALLDIR/webapps/cas; jar xf cas.war )

# 2 cas webapp backup

# 3 new cas config
mkdir $V_SITES_INSTALLDIR/bin_backup_pre_p11
cp -r $V_SITES_INSTALLDIR/bin/* $V_SITES_INSTALLDIR/bin_backup_pre_p11
cp -r cas_upgrade/config/cas/* $V_SITES_INSTALLDIR/bin

# 4 tweak cas config
bindir=$V_SITES_INSTALLDIR/bin
for i in $bindir/cas.properties $bindir/customBeans.xml $bindir/deployerConfigContext.xml $bindir/host.properties $bindir/jbossTicketCacheReplicationConfig.xml $bindir/log4j.xml $bindir/cas-spring-configuration/customDefaultWEMSSObeans.xml; do
  echo correcting cas configuration in $i
  /vagrant/scripts/diffwrap.sh $i sed -i \"s/@CSConnectPrefix@/http/g\" $i
  /vagrant/scripts/diffwrap.sh $i sed -i \"s/@hostname@/$V_HOSTNAME/g\" $i
  /vagrant/scripts/diffwrap.sh $i sed -i \"s/@portnumber@/$V_PORT/g\" $i
  /vagrant/scripts/diffwrap.sh $i sed -i \"s/@context-path@/cs/g\" $i
  /vagrant/scripts/diffwrap.sh $i sed -i \"s/@unique_id@/$V_HOSTNAME-$V_PORT-uniqueid/g\" $i
  /vagrant/scripts/diffwrap.sh $i sed -i \"s/@CASHostNameActual@/$V_HOSTNAME/g\" $i
  /vagrant/scripts/diffwrap.sh $i sed -i \"s/@cas.log@/\\/tmp\\/cas.log/g\" $i
done

# 5 cas jboss cluster
f=$V_SITES_INSTALLDIR/bin/jbossTicketCacheReplicationConfig.xml
/vagrant/scripts/diffwrap.sh $f sed -i \"s/48866/45678/g\" $f
/vagrant/scripts/diffwrap.sh $f sed -i \"s/TreeCache-Cluster/$V_HOSTNAME-TreeCache-Cluster/g\" $f

# 6 sites webapp
cp -r sites_webapp/* $V_TOMCAT_INSTALLDIR/webapps/cs

# 7 sites satellite.properties
f=$V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/classes/satellite.properties
/vagrant/scripts/diffwrap.sh $f sed -i \"/^transparent.content-type.pattern=/d\" $f
/vagrant/scripts/diffwrap.sh $f "echo 'transparent.content-type.pattern=text/.*|.*xml(?!formats).*' >> $f"

# 8 rss webapp

# 9 rss satellite.properties

# 10 sites install
cp -r sites_install/* $V_SITES_INSTALLDIR

# 11 csdt

# 12 assetpublishcallback & dataunpacker
f=$V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/classes/AdvPub.xml
/vagrant/scripts/diffwrap.sh $f /vagrant/scripts/xmlput.sh $f /vagrant/scripts/patch11/fragments/assetpublishcallback.xml before //bean[1]
/vagrant/scripts/xmlput.sh $f /vagrant/scripts/patch11/fragments/dataunpacker.xml before //bean[#attribute/id=\"DataUnpacker\"]/property[1]

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
f=$V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/web.xml
/vagrant/scripts/diffwrap.sh $f /vagrant/scripts/xmlput.sh $f /vagrant/scripts/patch11/fragments/noaccess.xml after //welcome-file-list
f=$V_TOMCAT_INSTALLDIR/webapps/cas/WEB-INF/web.xml
/vagrant/scripts/diffwrap.sh $f /vagrant/scripts/xmlput.sh $f /vagrant/scripts/patch11/fragments/noaccess.xml after //welcome-file-list

# 17 ContentSecurityFilter, place the filter as the first filter after the error-page element, and put the filter-mapping after the first filter-mapping
# first cs
f=$V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/web.xml
/vagrant/scripts/diffwrap.sh $f /vagrant/scripts/xmlput.sh $f /vagrant/scripts/patch11/fragments/contentsecurityfilter.xml before //filter[1]
/vagrant/scripts/diffwrap.sh $f /vagrant/scripts/xmlput.sh $f /vagrant/scripts/patch11/fragments/contentsecurityfiltermapping.xml before //filter-mapping[1]
# then cas
f=$V_TOMCAT_INSTALLDIR/webapps/cas/WEB-INF/web.xml
/vagrant/scripts/diffwrap.sh $f /vagrant/scripts/xmlput.sh $f /vagrant/scripts/patch11/fragments/contentsecurityfilter.xml before //filter[1]
/vagrant/scripts/diffwrap.sh $f /vagrant/scripts/xmlput.sh $f /vagrant/scripts/patch11/fragments/contentsecurityfiltermapping.xml before //filter-mapping[1]

# 18 eloqua filter, place the filter as the first filter after the error-page element, and put the filter-mapping after the first filter-mapping
f=$V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/web.xml
/vagrant/scripts/diffwrap.sh $f /vagrant/scripts/xmlput.sh $f /vagrant/scripts/patch11/fragments/eloquafilter.xml before //filter[1]
/vagrant/scripts/diffwrap.sh $f /vagrant/scripts/xmlput.sh $f /vagrant/scripts/patch11/fragments/eloquafiltermapping.xml before //filter-mapping[1]

# 19 ckeditor bug
f=$V_TOMCAT_INSTALLDIR/webapps/cs/ckeditor/config.js
/vagrant/scripts/diffwrap.sh $f sed -i \"/config.fullPage/ r /vagrant/scripts/patch11/fragments/configprotectedsource.js\" $f

# 20 ldap caseAware

# 21 TODO reindex

# 22 revisions
f=$V_SITES_INSTALLDIR/futuretense.ini
/vagrant/scripts/diffwrap.sh $f "echo 'cs.deleteExcessRevisionsFromDisk=true' >> $f"

# 23 TODO email ssl/tls

# 24 eloqua loggers
f=$V_TOMCAT_INSTALLDIR/webapps/cs/WEB-INF/classes/log4j.properties
/vagrant/scripts/diffwrap.sh $f "echo 'log4j.logger.oracle.wcsites.eloquaintegration=INFO' >> $f"
/vagrant/scripts/diffwrap.sh $f "echo 'log4j.logger.oracle.wcsites.eloquaintegration.jsp=INFO' >> $f"

# 25 youtube assets
f=$V_SITES_INSTALLDIR/futuretense.ini
/vagrant/scripts/diffwrap.sh $f "echo 'cs.youtubeapikey=provideYourOwnKey' >> $f"

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
f=$V_SITES_INSTALLDIR/futuretense_xcel.ini
/vagrant/scripts/diffwrap.sh $f sed -i \"s/xcelerate.treeType=OMTree/xcelerate.treeType=DojoTree/g\" $f


# shutdown
shutdown.sh -force
