#!/bin/sh

file_extensions_to_scan="properties ini wsdl xml"

#if [ ! -f $V_SITES_INSTALLDIR/.renamed ]; then
	# set desired host:port
	touch $V_SITES_INSTALLDIR/.renamed
	for dir in $@; do
		/vagrant/scripts/findreplace.sh $dir $V_HOSTNAME $V_NEW_COMPOSE_HOSTNAME "$file_extensions_to_scan" | tee -a $V_SITES_INSTALLDIR/.renamed
		/vagrant/scripts/findreplace.sh $dir $V_PORT $V_NEW_COMPOSE_PORT "$file_extensions_to_scan" | tee -a $V_SITES_INSTALLDIR/.renamed
	done
	# todo also systemsatellite and webroot tables
#fi
