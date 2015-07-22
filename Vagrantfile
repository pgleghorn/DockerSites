# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.vm.box_check_update = false
  config.vm.network "public_network", bridge: 'wlan2'
  config.vm.synced_folder "C:/Users/pgleghor/Dropbox/vagrant/kits", "/kits"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.gui = true
  end
config.vm.provision "shell", inline: <<-SHELL

  echo
  echo "*** setup system"
  echo

  t1=`date +%s`
  hostname v6
  ipaddr="`ifconfig -a | grep 192 | cut -f2 -d':' | cut -f1 -d' '`"
  echo "$ipaddr v6-ext" >> /etc/hosts
  echo "127.0.0.1 v6" >> /etc/hosts
  chkconfig --level 345 iptables off
  chkconfig --level 345 ip6tables off
  /etc/init.d/iptables stop
  /etc/init.d/ip6tables stop
  usermod -p '$1$aUtH9gPt$/ykXsfv.w52tq6FlBIQZC0' root # pass1234

  echo
  echo "*** setup user"
  echo

  useradd -m -p '$1$aUtH9gPt$/ykXsfv.w52tq6FlBIQZC0' phil # pass1234
  cd /home/phil
  echo 'alias psme="ps aux | grep $USER"' >> .bash_profile
  echo 'alias logmon="tail -n0 -f $HOME/tomcat/logs/* $HOME/oracle/webcenter/sites/logs/*"' >> .bash_profile

  echo
  echo "*** setup java"
  echo

  echo 'export JAVA_HOME=$HOME/jdk1.7.0_79' >> .bash_profile
  echo 'PATH=$JAVA_HOME/bin:$PATH' >> .bash_profile
  gunzip < /kits/jdk-7u79-linux-x64.tar.gz | tar xf -
  chown -R phil:phil jdk1.7.0_79

  echo
  echo "*** setup tomcat"
  echo

  gunzip < /kits/apache-tomcat-7.0.62.tar.gz | tar xf -
  mv apache-tomcat-7.0.62 tomcat
  echo 'PATH=$HOME/tomcat/bin:$PATH' >> .bash_profile
  echo 'CATALINA_PID=$HOME/catalina.pid' >> tomcat/bin/setenv.sh
  echo 'CLASSPATH=$HOME/oracle/webcenter/sites/bin' >> tomcat/bin/setenv.sh
  echo 'JAVA_OPTS="-Dfile.encoding=UTF-8 -Xmx512m -XX:MaxPermSize=256m -Dnet.sf.ehcache.enableShutdownHook=true "' >> tomcat/bin/setenv.sh
  # ..tomcat-users.xml
  sed -i '36i\
<role rolename="manager-gui"/> \
<role rolename="admin-gui"/> \
<user username="tomcat" password="pass1234" roles="manager-gui,admin-gui"/> \
' tomcat/conf/tomcat-users.xml
  # ..server.xml
  sed -i '128i\
<Context path="/cs" docBase="cs" reloadable="true" crossContext="true"> \
<Resource name="csDataSource" auth="Container" type="javax.sql.DataSource" \
maxActive="50" maxIdle="10" \
username="sa" \
password="" \
driverClassName="org.hsqldb.jdbcDriver" \
url="jdbc:hsqldb:/home/phil/oracle/webcenter/sites/hsqldb/csdb"/> \
</Context>\
' tomcat/conf/server.xml
  # ..tools.jar
  cp jdk1.7.0_79/lib/tools.jar tomcat/lib
  chown -R phil:phil tomcat

  echo
  echo "*** setup hsqldb"
  echo

  unzip -q -jd tomcat/lib /kits/hsqldb_1_8_0_10.zip hsqldb/lib/hsqldb.jar
  chown phil:phil tomcat/lib/hsqldb.jar

  echo
  echo "*** unpacking sites"
  echo

  mkdir cs-tmp
  unzip -q -jd cs-tmp /kits/V38958-01.zip WebCenterSites_11.1.1.8.0/WCS_Sites/WCS_Sites.zip
  cd cs-tmp
  unzip -q WCS_Sites.zip
  cd Sites
  # ..re-enable hsqldb db option for tomcat
  sed -i '1916i\
<COMBOBOXENTRY TEXT="HSQL Database Engine" HASHVALUE="HSQLDB">\
<\/COMBOBOXENTRY>\
' cscore.xml
  chmod 755 csInstall.sh
  # ..silent installer choices
  mkdir -p /home/phil/oracle/webcenter/sites/ominstallinfo
  cat > /home/phil/oracle/webcenter/sites/ominstallinfo/silentconfig.ini <<ENDSILENTCONFIG
Avisports=true
CASHostNameActual=v6
CASHostNameLocal=v6
CASHostName=v6
CASPortNumber=8080
CASPortNumberLocal=8080
CatalogCentre=true
CommerceConnector=false
ContentCentre=true
CSInstallAccountName=ContentServer
CSInstallAccountPassword={AES}57FB2563B615AB6630483ED0132A5BEA
CSInstallAppName=fwadmin
CSInstallAppPassword={AES}88A21D9353F9BDDCD80751A90800F620
CSInstallAppServerPath=/home/phil/tomcat
CSInstallAppServerType=tomcat5
CSInstallDatabaseType=HSQLDB
CSInstallDBDSN=csDataSource
CSInstallDirectory=/home/phil/oracle/webcenter/sites
CSInstallPlatformType=APPSERVER
CSInstallSharedDirectory=/home/phil/oracle/webcenter/Shared
CSInstallType=single
CSInstallWebServerAddress=v6
CSInstallWebServerPort=8080
Development=true
IsWEMInstall=TRUE
LoggerName=org.apache.commons.logging.impl.Log4JLogger
MarketingStudio=true
sCgiPath=/cs/
SSUserName=SatelliteServer
SSUserPassword={AES}57FB2563B615AB6630483ED0132A5BEA
ENDSILENTCONFIG
  chown -R phil:phil /home/phil/oracle
  # ..installer.ini changes for silent install
  sed -i 's/nodisplay=false/nodisplay=true/' install.ini
  sed -i 's/loadfile=/loadfile=\\/home\\/phil\\/oracle\\/webcenter\\/sites\\/ominstallinfo\\/silentconfig.ini/' install.ini
  chown -R phil:phil /home/phil/cs-tmp
  
  echo
  echo "*** running Sites install" 
  echo

  sudo -i -u phil sh -c "cd /home/phil/cs-tmp/Sites; /vagrant/wait.sh | ./csInstall.sh -silent"
  # fix esapi loading
  mkdir /home/phil/esapi
  cp /home/phil/oracle/webcenter/sites/bin/ESAPI.properties /home/phil/esapi
  cp /home/phil/oracle/webcenter/sites/bin/validation.properties /home/phil/esapi

  echo
  echo "*** installing support tools"
  echo

  mkdir /home/phil/cs-tmp/supporttools
  unzip -q -d /home/phil/cs-tmp/supporttools /kits/SupportTools-4.3.zip
  chown -R phil:phil /home/phil/cs-tmp/supporttools
  sudo -i -u phil sh -c "java -cp \"/home/phil/tomcat/webapps/cs/WEB-INF/lib/*:/home/phil/tomcat/lib/*\" COM.FutureTense.Apps.CatalogMover -p password -u ContentServer -b http://v6:8080/cs/CatalogManager -x import_all -d /home/phil/cs-tmp/supporttools"

  echo
  echo "*** installing patch 10"
  echo

  mkdir /home/phil/cs-tmp/p10
  cd /home/phil/cs-tmp/p10
  unzip -q -d . /kits/p20981509_111180_Generic.zip
  chown -R phil:phil /home/phil/cs-tmp/p10
  cd patch
  # 1 elements
  sudo -i -u phil sh -c "java -cp \"/home/phil/tomcat/webapps/cs/WEB-INF/lib/*:/home/phil/tomcat/lib/*\" COM.FutureTense.Apps.CatalogMover -p xceladmin -u fwadmin -b http://v6:8080/cs/CatalogManager -x import_all -d /home/phil/cs-tmp/p10/patch/elements"
  # 2 eloqua
  # 3 sites webapp
  cp -r sites_webapp/* /home/phil/tomcat/webapps/cs
  # 4 satellite.properties
  sed -i 'd/^transparent.content-type.pattern=/' /home/phil/tomcat/webapps/cs/WEB-INF/classes/satellite.properties
  echo "transparent.content-type.pattern=text/.*|.*xml(?!formats).*" >> /home/phil/tomcat/webapps/cs/WEB-INF/classes/satellite.properties
  # 5 cas webapp
  cp -r cas_webapp/* /home/phil/tomcat/webapps/cas
  # 6 rss webapp
  # 7 same as 4
  # 8 sites folder
  cp -r sites_install/* /home/phil/oracle/webcenter/sites
  # 9 csdt
  # 10 avisports elements
  sudo -i -u phil sh -c "java -cp \"/home/phil/tomcat/webapps/cs/WEB-INF/lib/*:/home/phil/tomcat/lib/*\" COM.FutureTense.Apps.CatalogMover -p xceladmin -u fwadmin -b http://v6:8080/cs/CatalogManager -x import_all -d /home/phil/cs-tmp/p10/patch/avisports/elements"
  # 11a advpub
  sed -i '96i    <bean id="AssetPublishCallback" class="com.fatwire.realtime.messaging.AssetPublishCallbackImpl" singleton="false"/>' /home/phil/tomcat/webapps/cs/WEB-INF/classes/AdvPub.xml
  # 11b advpub
  sed -i '42i    <property name="assumeHungTime" value="600000" />' /home/phil/tomcat/webapps/cs/WEB-INF/classes/AdvPub.xml
  # 12 spring jar
  rm -f /home/phil/tomcat/webapps/cs/WEB-INF/lib/spring-2.5.5.jar
  rm -f /home/phil/oracle/webcenter/sites/Sun/lib/spring-2.5.5.jar
  rm -f /home/phil/tomcat/webapps/cas/WEB-INF/lib/spring-2.5.6.jar
  rm -f /home/phil/oracle/webcenter/sites/ominstallinfo/cas/WEB-INF/lib/spring-2.5.6.jar
  # 13 xwork jar
  rm -f /home/phil/tomcat/webapps/cs/WEB-INF/lib/xwork-2.0.4.jar
  # 14 fileupload jar
  rm -f /home/phil/tomcat/webapps/cs/WEB-INF/lib/commons-fileupload-1.2.1.jar
  # 15 more fileupload jar
  # 16a web.xml
  sed -i '123i\
<listener>\
<listener-class>net.sf.ehcache.constructs.web.ShutdownListener</listener-class>\
</listener>' /home/phil/tomcat/webapps/cs/WEB-INF/web.xml
  # 16b shutdownhook, already done
  # 17 both web.xml
  sed -i '264i\
<security-constraint>\
<web-resource-collection>\
<web-resource-name>NoAccess</web-resource-name>\
<url-pattern>/jsp/cs_deployed/*</url-pattern>\
</web-resource-collection>\
<auth-constraint/>\
<user-data-constraint>\
<description/>\
<transport-guarantee>NONE</transport-guarantee>\
</user-data-constraint>\
</security-constraint>' /home/phil/tomcat/webapps/cs/WEB-INF/web.xml
  sed -i '231i\
<security-constraint>\
<web-resource-collection>\
<web-resource-name>NoAccess</web-resource-name>\
<url-pattern>/jsp/cs_deployed/*</url-pattern>\
</web-resource-collection>\
<auth-constraint/>\
<user-data-constraint>\
<description/>\
<transport-guarantee>NONE</transport-guarantee>\
</user-data-constraint>\
</security-constraint>' /home/phil/tomcat/webapps/cas/WEB-INF/web.xml
  # 18 todo content security filter
  # 19 eloqua - skip
  # 20 todo ckeditor
  # 21 caseaware - skip
  # 22 reindex - skip (warn todo this)
  # 23 revisions
  echo "cs.deleteExcessRevisionsFromDisk=true" >> /home/phil/oracle/webcenter/sites/futuretense.ini
  # 24 eloqua - skip
  # 25 eloqua - skip

  echo
  echo "*** misc sites config ***"
  echo

  sed -i 's/cs.timeout=.*/cs.timeout=18000/' /home/phil/oracle/webcenter/sites/futuretense.ini
  sed -i 's/advancedUI.enableAssetForms=false/advancedUI.enableAssetForms=true/' /home/phil/oracle/webcenter/sites/futuretense_xcel.ini

  echo
  echo "*** Install finished ***"
  echo

  cat /etc/hosts
  ps -fu phil
  ifconfig -a
  df -h
  t2=`date +%s`
  t3=`expr $t2 - $t1`
  duration=`date -u -d @$t3 +"%-M minutes %-S seconds"`

  echo
  echo "*** Provisioned in $duration ***"
  echo

  echo "Now add this to your host file (/etc/hosts, or C:\\Windows\\System32\\drivers\\etc\\hosts)"
  echo "    $ipaddr v6"
  echo "eg for Windows"
  echo "    type $ipaddr v6 >> C:\\Windows\\System32\\drivers\\etc\\hosts"
  echo "or unix"
  echo "    sudo echo \\"$ipaddr v6\\" >> /etc/hosts"
  echo "then goto http://v6:8080/cs/"
  echo
  echo "For shell access, you can login as vagrant user directly with:"
  echo "    vagrant ssh"
  echo "or any other user via ssh"
  echo "    ssh <user>@v6"
  echo "users are:"
  echo "    root : pass1234"
  echo "    phil : pass1234"
  echo "    vagrant : vagrant"
  echo 
  echo "To start X11, log onto the virtualbox console and then:"
  echo "    yum -y groupinstall \\"X Window System\\""
  echo "    yum -y groupinstall Desktop"
  echo "    yum -y groupinstall Fonts"
  echo "    yum -y install firefox"
  echo "    startx"
SHELL
end
