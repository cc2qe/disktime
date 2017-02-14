#!/bin/bash

if [[ -z "$1" ]]
then
    echo "usage: $0 <cmd>"
    exit 1
fi

CMD="$1"

DATE=`date "+%Y-%m-%d"`
TIME=`date "+%H:%M:%S"`
EPOCH=`date +%s`

ELAPSED_TIME=`/usr/bin/time -f "%e" sh -c "$CMD" 2>&1 >/dev/null`


echo -e "$DATE\t$TIME\t$EPOCH\t$ELAPSED_TIME"