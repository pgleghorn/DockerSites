#!/bin/sh

echo ""
echo "***"
echo "*** setup java"
echo "***"
echo ""

cd /tmp
echo "export JAVA_HOME=$V_JDK_INSTALLDIR" >> $V_UNIXUSERHOME/.bash_profile
echo "PATH=$V_JDK_INSTALLDIR/bin:\$PATH" >> $V_UNIXUSERHOME/.bash_profile
gunzip < /kits/jdk-7u79-linux-x64.tar.gz | tar xf -
cd jdk1.7.0_79
mkdir -p $V_JDK_INSTALLDIR
mv * $V_JDK_INSTALLDIR
chown -R $V_UNIXUSER:$V_UNIXUSER $V_JDK_INSTALLDIR
