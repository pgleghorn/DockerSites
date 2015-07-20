#!/bin/sh

# wait until sites install log asks us to restart tomcat

TARGET="^4. If the test is successful, press ENTER.$"
FILE=/home/phil/oracle/webcenter/sites/ominstallinfo/install_log.log
while true; do
  grep -q $TARGET $FILE 2>/dev/null
  if [ $? -eq 0 ]; then
    break;
  fi
  sleep 2
done

# start tomcat 
startup.sh > /dev/null 2>&1

# wait until tomcat is started and then output something

TARGET="^INFO: Server startup in .*ms$"
FILE=/home/phil/tomcat/logs/catalina.out
while true; do
  grep -q $TARGET $FILE 2>/dev/null
  if [ $? -eq 0 ]; then
    echo "finished";
    break;
  fi
  sleep 2
done
