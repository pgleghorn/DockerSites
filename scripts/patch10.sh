#!/bin/sh
  mkdir /home/phil/cs-tmp/p10
  cd /home/phil/cs-tmp/p10
  unzip -q -d . /kits/p20981509_111180_Generic.zip
  chown -R phil:phil /home/phil/cs-tmp/p10
  cd patch
  # 1 elements
  sudo -i -u phil sh -c "java -cp \"/home/phil/tomcat/webapps/cs/WEB-INF/lib/*:/home/phil/tomcat/lib/*\" COM.FutureTense.Apps.CatalogMover -p xceladmin -u fwadmin -b http://v8:8080/cs/CatalogManager -x import_all -d /home/phil/cs-tmp/p10/patch/elements"
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
  sudo -i -u phil sh -c "java -cp \"/home/phil/tomcat/webapps/cs/WEB-INF/lib/*:/home/phil/tomcat/lib/*\" COM.FutureTense.Apps.CatalogMover -p xceladmin -u fwadmin -b http://v8:8080/cs/CatalogManager -x import_all -d /home/phil/cs-tmp/p10/patch/avisports/elements"
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
