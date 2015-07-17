# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.vm.network "public_network", bridge: 'wlan2'
  config.vm.synced_folder "/home/phil/Documents/kits", "/kits"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
config.vm.provision "shell", inline: <<-SHELL
  # setup system
  date
  id
  hostname v6
  hostname
  ipaddr="`ifconfig -a | grep 192 | cut -f2 -d':' | cut -f1 -d' '`"
  echo "$ipaddr v6" >> /etc/hosts
  chkconfig --level 345 iptables off
  chkconfig --level 345 ip6tables off
  /etc/init.d/iptables stop
  /etc/init.d/ip6tables stop
  usermod -p '$1$aUtH9gPt$/ykXsfv.w52tq6FlBIQZC0' root # pass1234
  # setup user
  useradd -m -p '$1$aUtH9gPt$/ykXsfv.w52tq6FlBIQZC0' phil # pass1234
  cd /home/phil
  echo 'alias psme="ps aux | grep $USER"' >> .bash_profile
  echo 'alias logmon="tail -n0 -f $HOME/tomcat/logs/* $HOME/oracle/webcenter/sites/logs/*"' >> .bash_profile
  # setup java
  echo 'export JAVA_HOME=$HOME/jdk1.7.0_79' >> .bash_profile
  echo 'PATH=$JAVA_HOME/bin:$PATH' >> .bash_profile
  echo "unpacking jdk..."
  gunzip < /kits/jdk-7u79-linux-x64.tar.gz | tar xf -
  chown -R phil:phil jdk1.7.0_79
  # setup tomcat
  echo "unpacking tomcat..."
  gunzip < /kits/apache-tomcat-7.0.62.tar.gz | tar xf -
  mv apache-tomcat-7.0.62 tomcat
  echo 'PATH=$HOME/tomcat/bin:$PATH' >> .bash_profile
  echo 'CATALINA_PID=$HOME/catalina.pid' >> tomcat/bin/setenv.sh
  echo 'CLASSPATH=$HOME/oracle/webcenter/sites/bin' >> tomcat/bin/setenv.sh
  echo 'JAVA_OPTS="-Dfile.encoding=UTF-8 -Xmx512m -XX:MaxPermSize=256m -Dnet.sf.ehcache.enableShutdownHook=true "' >> tomcat/bin/setenv.sh
  chown -R phil:phil /home/phil/tomcat
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
  # ..hsqldb
  echo "unpacking hsqldb..."
  unzip -q -jd tomcat/lib /kits/hsqldb_1_8_0_10.zip hsqldb/lib/hsqldb.jar
  # ..tools.jar
  cp jdk1.7.0_79/lib/tools.jar tomcat/lib
  # unpack sites
  mkdir cs-tmp
  echo "unpacking Sites 1 of 2..."
  unzip -q -jd cs-tmp /kits/V38958-01.zip WebCenterSites_11.1.1.8.0/WCS_Sites/WCS_Sites.zip
  cd cs-tmp
  echo "unpacking Sites 2 of 2..."
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
  
  
  # run sites install, first to build the war
  sudo -i -u phil sh -c "cd /home/phil/cs-tmp/Sites; echo | ./csInstall.sh -silent"
  # fix esapi loading
  mkdir /home/phil/esapi
  cp /home/phil/oracle/webcenter/sites/bin/ESAPI.properties /home/phil/esapi
  cp /home/phil/oracle/webcenter/sites/bin/validation.properties /home/phil/esapi
  # startup tomcat
  sudo -i -u phil startup.sh
  echo "waiting for tomcat to start..."
  sleep 120
  tail -1000 /home/phil/tomcat/logs/catalina.out
  
  
  # run sites installer again to do the second part
  sed -i 's/dodeployments=true/dodeployments=false/' install.ini
  sed -i 's/autodeploy=true/autodeploy=false/' install.ini
  sed -i 's/doimports=false/doimports=true/' install.ini
  sed -i 's/dodbinitialization=false/dodbinitialization=true/' install.ini
  sed -i 's/dopingdb=false/dopingdb=true/' install.ini
  sudo -i -u phil sh -c "cd /home/phil/cs-tmp/Sites; echo | ./csInstall.sh -silent"
  # one more restart
  echo "finished installing sites"
  
  
  # install patch 10
  mkdir /home/phil/cs-tmp/p10
  cd /home/phil/cs-tmp/p10
  echo "unpacking patch 10..."
  unzip -q -d . /kits/p20981509_111180_Generic.zip
  cd patch
  echo "installing patch 10..."
  # 1 elements
  sudo -i -u phil sh -c "java -cp \"/home/phil/tomcat/webapps/cs/WEB-INF/lib/*:/home/phil/tomcat/lib/*\" COM.FutureTense.Apps.CatalogMover -p xceladmin -u fwadmin -b http://v6:8080/cs/CatalogManager -x import_all -d /home/phil/cs-tmp/p10/patch/elements"
  # 2 eloqua
  # 3 sites webapp
  cp -r sites_webapp/* /home/phil/tomcat/webapps/cs
  # 4 satellite.properties
  sed -i 's/transparent.content-type.pattern=.*/transparent.content-type.pattern=text\/.*|.*xml\(?!formats\).*/' /home/phil/tomcat/webapps/cs/WEB-INF/classes/satellite.properties
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
  rm /home/phil/tomcat/webapps/cs/WEB-INF/lib/spring-2.5.5.jar
  rm /home/phil/oracle/webcenter/sites/Sun/lib/spring-2.5.5.jar
  rm /home/phil/tomcat/webapps/cas/WEB-INF/lib/spring-2.5.6.jar
  rm /home/phil/oracle/webcenter/sites/ominstallinfo/cas/WEB-INF/lib/spring-2.5.6.jar
  # 13 xwork jar
  rm /home/phil/tomcat/webapps/cs/WEB-INF/lib/xwork-2.0.4.jar
  # 14 fileupload jar
  rm /home/phil/tomcat/webapps/cs/WEB-INF/lib/commons-fileupload-1.2.1.jar
  # 15 more fileupload jar
  # 16a web.xml
  sed -i '123i\
<listener>\
<listener-class>net.sf.ehcache.constructs.web.ShutdownListener<\/listener-class>\
<\/listener>' /home/phil/tomcat/webapps/cs/WEB-INF/web.xml
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


  # misc
  sed -i 's/cs.timeout=.*/cs.timeout=18000/' /home/phil/oracle/webcenter/sites/futuretense.ini


  # other TODO
  # smarter install, dont run twice but instead wait for tomcat startup then continue
  # install supporttools
  # enable asset forms in admin UI
  # echo script to run as root in host, to add ip address for v6 to /etc/hosts
  # rss
  # httpd
  # puppetize it all: os / tomcat / sites / patch
  # further puppetizing: httpd / vanity url config
  # further platform: oel / wls / oraclexe


  # finished
  cat /etc/hosts
  ps -fu phil
  ifconfig -a
  df -h
  echo "Now goto http://$ipaddr:8080/cs/"
SHELL
end
