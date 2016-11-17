#!/bin/bash -a
. config.sh
docker run -p$V_PORT:$V_PORT -h $V_HOSTNAME vsinstall
