#!/bin/sh

# invoke like:
# diffwrap <file_to_watch> <command> <command_args>
# eg
# diffwrap /u00/tomcat/conf/server.xml sed -i -e "s/8080/9191/g" /u00/tomcat/conf/server.xml
# diffwrap /etc/hosts echo "127.0.0.1 newalias" >> /etc/hosts

FILETODIFF=$1
touch $FILETODIFF
shift
CMDTORUN=$@

cp $FILETODIFF /tmp/diffwrap_$$
echo ">>>>>>>> diffwrap running $CMDTORUN"
eval $CMDTORUN

diff /tmp/diffwrap_$$ $FILETODIFF | sed -e 's/^/    /g'

rm /tmp/diffwrap_$$
