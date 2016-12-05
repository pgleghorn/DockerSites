#!/bin/sh -a

. ./config.sh
env | grep V_ | sort
if [ -z $ORACLE_USER ] &&  [ -z $ORACLE_PASSWORD ]; then
	echo "Please set ORACLE_USER and ORACLE_PASSWORD env vars"
	exit
fi
downloadargs=" --build-arg ORACLE_USER=$ORACLE_USER --build-arg ORACLE_PASSWORD=$ORACLE_PASSWORD"
vargs=" --build-arg V_SCRIPTS=$V_SCRIPTS --build-arg V_CONFIG=$V_CONFIG "
#docker build $vargs $downloadargs -t wcsbase $@ -f Dockerfile-wcsbase .
#docker build $vargs -t wcsinstall $@ -f Dockerfile-wcsinstall .
#docker build $vargs -t wcspatch $@ -f Dockerfile-wcspatch .
#docker build $vargs -t wcsrun $@ -f Dockerfile-wcsrun .

docker build $vargs $downloadargs -t rssbase $@ -f Dockerfile-rssbase .
