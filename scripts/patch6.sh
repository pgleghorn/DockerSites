#!/bin/sh
  mkdir /home/phil/cs-tmp/p6
  cd /home/phil/cs-tmp/p6
  unzip -q -d . /kits/p19278850_111180_Generic.zip
  chown -R phil:phil /home/phil/cs-tmp/p6
  cd patch
  # 1 elements
  sudo -i -u phil sh -c "java -cp \"/home/phil/tomcat/webapps/cs/WEB-INF/lib/*:/home/phil/tomcat/lib/*\" COM.FutureTense.Apps.CatalogMover -p xceladmin -u fwadmin -b http://v8:8080/cs/CatalogManager -x import_all -d /home/phil/cs-tmp/p6/patch/elements"
  # 2 sites webapp
  cp -r sites_webapp/* /home/phil/tomcat/webapps/cs
  # 3 satellite.properties
  sed -i 'd/^transparent.content-type.pattern=/' /home/phil/tomcat/webapps/cs/WEB-INF/classes/satellite.properties
  echo "transparent.content-type.pattern=text/.*|.*xml(?!formats).*" >> /home/phil/tomcat/webapps/cs/WEB-INF/classes/satellite.properties
  # 4 cas webapp
  cp -r cas_webapp/* /home/phil/tomcat/webapps/cas
  # 5 rss webapp
  # 6 same as 3
  # 7 sites folder
  cp -r sites_install/* /home/phil/oracle/webcenter/sites
  # 8 csdt
  # 9 avisports elements
  sudo -i -u phil sh -c "java -cp \"/home/phil/tomcat/webapps/cs/WEB-INF/lib/*:/home/phil/tomcat/lib/*\" COM.FutureTense.Apps.CatalogMover -p xceladmin -u fwadmin -b http://v8:8080/cs/CatalogManager -x import_all -d /home/phil/cs-tmp/p6/patch/avisports/elements"
  # 10 advpub
  sed -i '96i    <bean id="AssetPublishCallback" class="com.fatwire.realtime.messaging.AssetPublishCallbackImpl" singleton="false"/>' /home/phil/tomcat/webapps/cs/WEB-INF/classes/AdvPub.xml
  # 11 spring jar
  rm -f /home/phil/tomcat/webapps/cs/WEB-INF/lib/spring-2.5.5.jar
  rm -f /home/phil/oracle/webcenter/sites/Sun/lib/spring-2.5.5.jar
  rm -f /home/phil/tomcat/webapps/cas/WEB-INF/lib/spring-2.5.6.jar
  rm -f /home/phil/oracle/webcenter/sites/ominstallinfo/cas/WEB-INF/lib/spring-2.5.6.jar
  # 12 fileupload jar
  rm -f /home/phil/tomcat/webapps/cs/WEB-INF/lib/commons-fileupload-1.2.1.jar
  # 13 more fileupload jar - TODO
  # 14a web.xml
  sed -i '123i\
<listener>\
<listener-class>net.sf.ehcache.constructs.web.ShutdownListener</listener-class>\
</listener>' /home/phil/tomcat/webapps/cs/WEB-INF/web.xml
  # 14b shutdownhook, already done
  # 15 ldap.type
  # 16 reindex - skip (warn todo this)
