#!/bin/sh

INPUTFILE=${1:?input file}
FRAGMENTFILE=${2:?fragment file}
PLACE=${3:?place}
XPATH=${4:?xpath}

inputfiledir=`dirname $INPUTFILE`
inputfilename=`basename $INPUTFILE`
placeholder="FAIRLYUNIQUEXMLPUTPLACEHOLDER"

# decide whether to "ins" or "touch"
case $PLACE in
	at)
		cmd="touch /files/$inputfilename$XPATH/$placeholder"
		;;
        before | after)
		cmd="ins $placeholder $PLACE /files/$inputfilename$XPATH"
		;;
        *)
            echo "$PLACE is not one of: before, after, at"
            exit 1
esac

# load the xml and put in the fragment placeholder
augtool --echo  --noautoload --root $inputfiledir <<EOF
set /augeas/load/xml/lens "Xml.lns"
set /augeas/load/xml/incl $inputfilename
load
$cmd
save
quit
EOF

# replace placeholder with fragment
sed -i -e "/$placeholder/r $FRAGMENTFILE" $INPUTFILE
sed -i -e "/$placeholder/d" $INPUTFILE
