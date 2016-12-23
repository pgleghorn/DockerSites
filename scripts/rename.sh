#!/bin/sh

file_extensions_to_scan="properties ini wsdl xml"

# set desired host:port
for dir in $@; do
	findreplace.sh $dir $V_HOSTNAME $V_NEW_COMPOSE_HOSTNAME "$file_extensions_to_scan" | tee -a /tmp/.renamed
	findreplace.sh $dir $V_PORT $V_NEW_COMPOSE_PORT "$file_extensions_to_scan" | tee -a /tmp/.renamed
done
# todo also systemsatellite and webroot tables
