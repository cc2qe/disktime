#!/bin/bash

if [[ -z "$1" ]]
then
    echo "usage: $0 <dir>"
    exit 1
fi

DIR="$1"


TFILE=`mktemp -d -p $DIR`
for i in {1..100}
do
    echo $i > $TFILE/$i.txt
done

ls -lhtr $TFILE

rm -r $TFILE
