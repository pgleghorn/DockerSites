#!/bin/sh -a

echo java
sleep 5

# unpack
cd /tmp
gunzip < /kits/jdk-7u79-linux-x64.tar.gz | tar xf -
cd jdk1.7.0_79
mv * $V_JDK_INSTALLDIR

# profile
f=$V_UNIXUSERHOME/.bash_profile
diffwrap.sh $f "echo export JAVA_HOME=$V_JDK_INSTALLDIR >> $f"
diffwrap.sh $f "echo export PATH='$'JAVA_HOME/bin:'$'PATH >> $f"
