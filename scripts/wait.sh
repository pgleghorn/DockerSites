#!/bin/sh 

# wait until sites install log asks us to restart tomcat
TARGET="^4. If the test is successful, press ENTER.$"
FILE=$V_SITES_INSTALLDIR/ominstallinfo/install_log.log
while true; do
  grep -q $TARGET $FILE 2>/dev/null
  if [ $? -eq 0 ]; then
    break;
  fi
  sleep 2
done

date > /tmp/t1

# start tomcat 
startup.sh > /dev/null 2>&1

sleep 20

# wait until tomcat is started and then output something
TARGET="^INFO: Server startup in .*ms$"
FILE=$V_TOMCAT_INSTALLDIR/logs/catalina.out
while true; do
  grep -q $TARGET $FILE 2>/dev/null
  if [ $? -eq 0 ]; then
    break;
  fi
  sleep 2
done
echo "woke up"

