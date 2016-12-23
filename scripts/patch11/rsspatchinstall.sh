#!/bin/sh -a

. $V_CONFIG
. $HOME/.bash_profile
echo patch11
sleep 5

# skip this for now
exit

mkdir -p /tmp/rssp11
cd /tmp/rssp11
unzip -q -d . /kits/p21494888_111180_Generic.zip
chown -R $V_UNIXUSER:$V_UNIXGROUP /tmp/rssp11
cd patch
 
# 1 cas war
# 2 cas webapp backup
# 3 new cas config
# 4 tweak cas config
# 5 cas jboss cluster
# 6 sites webapp
# 7 sites satellite.properties

# 8 rss webapp
# 9 rss satellite.properties

# 10 sites install
# 11 csdt
# 12 assetpublishcallback & dataunpacker
# 13 remove old jars
# 14 fileupload jar
# 15a shutdown listener, already done
# 15b shutdown hook, already done
# 16 NoAccess, place it after the welcome-file-list element
# 17 ContentSecurityFilter, place the filter as the first filter after the error-page element, and put the filter-mapping after the first filter-mapping
# 18 eloqua filter, place the filter as the first filter after the error-page element, and put the filter-mapping after the first filter-mapping
# 19 ckeditor bug
# 20 ldap caseAware
# 21 TODO reindex
# 22 revisions
# 23 TODO email ssl/tls
# 24 eloqua loggers
# 25 youtube assets

# startup

# 26 patch elements
# 27 eloqua elements
# 28 avisports elements

# other, dojo tree

# shutdown
