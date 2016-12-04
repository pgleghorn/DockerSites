#!/bin/sh -a

. ./config.sh
env | grep V_ | sort
if [ -z $ORACLE_USER ] &&  [ -z $ORACLE_PASSWORD ]; then
	echo "Please set ORACLE_USER and ORACLE_PASSWORD env vars"
	exit
fi
downloadargs=" --build-arg ORACLE_USER=$ORACLE_USER --build-arg ORACLE_PASSWORD=$ORACLE_PASSWORD"
vargs=" --build-arg V_SCRIPTS=$V_SCRIPTS --build-arg V_CONFIG=$V_CONFIG "
docker build $vargs $downloadargs -t vsbase $@ -f Dockerfile-base .
docker build $vargs -t vsinstall $@ -f Dockerfile-install .
docker build $vargs -t vspatch $@ -f Dockerfile-patch .
docker build $vargs -t vsrun $@ -f Dockerfile-run .
