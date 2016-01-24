#!/bin/sh

. ./config.sh
vagrant up | tee -a $VAGRANT_LOGFILE
