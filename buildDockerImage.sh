if [ -z $ORACLE_USER ] &&  [ -z $ORACLE_PASSWORD ]; then
	echo "Please set ORACLE_USER and ORACLE_PASSWORD env vars"
	exit
fi
docker build --build-arg "ORACLE_USER=$ORACLE_USER" --build-arg "ORACLE_PASSWORD=$ORACLE_PASSWORD" -t vsbase $@ -f Dockerfile-base .
docker build -t vsinstall $@ -f Dockerfile-install .
docker build -t vsrun $@ -f Dockerfile-run .
