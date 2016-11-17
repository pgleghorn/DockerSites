#!/bin/sh

echo "\n***\n*** setup tomcat \n***\n\n"

# unpack
cd /tmp
gunzip < /kits/apache-tomcat-7.0.62.tar.gz | tar xf -
mkdir -p $V_TOMCAT_INSTALLDIR
cd apache-tomcat-7.0.62
mv * $V_TOMCAT_INSTALLDIR
chown -R $V_UNIXUSER:$V_UNIXGROUP $V_TOMCAT_INSTALLDIR

# profile
echo "PATH=$V_TOMCAT_INSTALLDIR/bin:\$PATH" >> $V_UNIXUSERHOME/.bash_profile
echo "CATALINA_PID=$V_TOMCAT_INSTALLDIR/catalina.pid" >> $V_TOMCAT_INSTALLDIR/bin/setenv.sh
echo "CLASSPATH=$V_SITES_INSTALLDIR/bin" >> $V_TOMCAT_INSTALLDIR/bin/setenv.sh
echo 'JAVA_OPTS=" -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8 -Xmx512m -XX:MaxPermSize=256m -Dnet.sf.ehcache.enableShutdownHook=true "' >> $V_TOMCAT_INSTALLDIR/bin/setenv.sh

# tomcat gui user
sed -i '36i\
<role rolename="manager-gui"/> \
<role rolename="admin-gui"/> \
<user username="tomcat" password="pass1234" roles="manager-gui,admin-gui"/> \
' $V_TOMCAT_INSTALLDIR/conf/tomcat-users.xml

# datasource
sed -i "128i\
<Context path=\"/cs\" docBase=\"cs\" reloadable=\"true\" crossContext=\"true\"> \
<Resource name=\"csDataSource\" auth=\"Container\" type=\"javax.sql.DataSource\" \
maxActive=\"50\" maxIdle=\"10\" username=\"sa\" password=\"\" \
driverClassName=\"org.hsqldb.jdbcDriver\" \
url=\"jdbc:hsqldb:$V_SITES_INSTALLDIR/hsqldb/csdb\"/> \
</Context>\
" $V_TOMCAT_INSTALLDIR/conf/server.xml

sed -i "s/<Connector port=\"8080\"/<Connector port=\"$V_PORT\"/g" $V_TOMCAT_INSTALLDIR/conf/server.xml

# tools.jar
cp $V_JDK_INSTALLDIR/lib/tools.jar $V_TOMCAT_INSTALLDIR/lib
