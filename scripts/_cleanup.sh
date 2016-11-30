#!/bin/sh

echo cleanup 
sleep 5

shutdown.sh -force
rm -rf $V_TOMCAT_INSTALLDIR/temp
