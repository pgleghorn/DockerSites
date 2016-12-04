#!/bin/sh

echo tomcat
sleep 5

# unpack
cd /tmp
gunzip < /kits/apache-tomcat-7.0.62.tar.gz | tar xf -
cd apache-tomcat-7.0.62
mv * $V_TOMCAT_INSTALLDIR

# tomcat env
f=$V_TOMCAT_INSTALLDIR/bin/setenv.sh
diffwrap.sh $f echo "CATALINA_PID=$V_TOMCAT_INSTALLDIR/catalina.pid >> $f"
diffwrap.sh $f echo "CLASSPATH=$V_SITES_INSTALLDIR/bin >> $f"
diffwrap.sh $f echo "CATALINA_OPTS=\' -Xloggc:$V_TOMCAT_INSTALLDIR/logs/verbosegc.log -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -verbose:gc -Djava.security.egd=file:/dev/./urandom -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8 -Xmx1024m -XX:MaxPermSize=512m -Dnet.sf.ehcache.enableShutdownHook=true \' >> $f"

# tomcat gui user
f=$V_TOMCAT_INSTALLDIR/conf/tomcat-users.xml 
diffwrap.sh $f xmlput.sh $f $V_SCRIPTS/fragments/tomcat_roles.xml at /tomcat-users 

# datasource
f=$V_TOMCAT_INSTALLDIR/conf/server.xml 
diffwrap.sh $f xmlput.sh $f $V_SCRIPTS/fragments/csdb.xml at //Host

# port
f=$V_TOMCAT_INSTALLDIR/conf/server.xml
diffwrap.sh $f sed -i "s/8080/$V_PORT/" $f

# tools.jar
cp $V_JDK_INSTALLDIR/lib/tools.jar $V_TOMCAT_INSTALLDIR/lib

# profile
f=$V_UNIXUSERHOME/.bash_profile
diffwrap.sh $f "echo export PATH=$V_TOMCAT_INSTALLDIR/bin:'$'PATH >> $f"
