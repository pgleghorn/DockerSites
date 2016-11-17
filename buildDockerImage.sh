docker build --build-arg "ORACLE_USER=$ORACLE_USER" --build-arg "ORACLE_PASSWORD=$ORACLE_PASSWORD" -t vsbase $@ -f Dockerfile-base .
docker build -t vsinstall $@ -f Dockerfile-install .
