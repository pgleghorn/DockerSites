#!/bin/sh

ORACLE_USER=${1:?oracle username}
ORACLE_PASSWORD=${2:?oracle password}
TO_DOWNLOAD=${3:?file to download}
TO_SAVE=${4:?filename to save}

v_cookie=/tmp/$$_cookie
v_useragent="Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101 Firefox/45.0"

v_Site2pstoreToken=`curl -s -A "$v_useragent" -L $TO_DOWNLOAD | grep site2pstoretoken | awk -Fsite2pstoretoken {'print $2'} | awk -F\= {'print $2'} | awk -F\" {'print $2'}`

curl -s -A "$v_useragent" -d 'ssousername='$ORACLE_USER'&password='$ORACLE_PASSWORD'&site2pstoretoken='$v_Site2pstoreToken -o /dev/null https://login.oracle.com/sso/auth -c $v_cookie

echo '.oracle.com	TRUE	/	FALSE	0	oraclelicense	accept-dbindex-cookie' >> $v_cookie

curl -A "$v_useragent" -b $v_cookie -o $TO_SAVE -L $TO_DOWNLOAD
