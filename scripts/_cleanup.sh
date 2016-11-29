#!/bin/sh

echo cleanup 
shutdown.sh -force
rm -rf $V_TOMCAT_INSTALLDIR/temp
