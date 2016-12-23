#!/bin/sh -a

. ./config.sh
env | grep V_ | sort
if [ -z $ORACLE_USER ] &&  [ -z $ORACLE_PASSWORD ]; then
	echo "Please set ORACLE_USER and ORACLE_PASSWORD env vars"
	exit
fi
downloadargs=" --build-arg ORACLE_USER=$ORACLE_USER --build-arg ORACLE_PASSWORD=$ORACLE_PASSWORD"

vargs=" --build-arg V_SCRIPTS=$V_SCRIPTS --build-arg V_CONFIG=$V_CONFIG "
#vargs=" --build-arg V_SCRIPTS=/vagrant/scripts --build-arg V_CONFIG=/vagrant/config.sh "

# TODO /kits data container

# wcs
docker build $vargs $downloadargs -t pgleghorn/wcsbase $@ -f Dockerfile-wcsbase .
docker build $vargs -t pgleghorn/wcsinstall $@ -f Dockerfile-wcsinstall .
docker build $vargs -t pgleghorn/wcspatch $@ -f Dockerfile-wcspatch .
docker build $vargs -t pgleghorn/wcsrun $@ -f Dockerfile-wcsrun .

# rss
docker build $vargs $downloadargs -t pgleghorn/rssbase $@ -f Dockerfile-rssbase .
docker build $vargs -t pgleghorn/rssinstall $@ -f Dockerfile-rssinstall .
docker build $vargs -t pgleghorn/rsspatch $@ -f Dockerfile-rsspatch .
docker build $vargs -t pgleghorn/rssrun $@ -f Dockerfile-rssrun .
