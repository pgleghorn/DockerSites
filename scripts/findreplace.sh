#!/bin/sh

DIR=${1:?directory}
FIND=${2:?target string}
REPLACE=${3:?replacement string}
FILE_EXTENSIONS=${4:?file extensions}

for i in $FILE_EXTENSIONS; do
	echo replacing $FIND with $REPLACE in files with .$i extension
	files=`find $DIR -type f -iname "*.$i" -print0 | xargs -0 grep $FIND | grep -v filedata | cut -f1 -d":" | sort | uniq`
	for j in $files; do
		echo "  found file $j"
                /vagrant/scripts/diffsed "s/$FIND/$REPLACE/g" $j | sed -e 's/^/    /g'
#                grep $FIND $j | sed -e 's/^/    /g'
#		sed -i -e "s/$FIND/$REPLACE/g" $j
#		grep $REPLACE $j | sed -e 's/^/    /g'
	done
done

