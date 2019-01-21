#!/bin/bash

#Program:
#	Program shows how to realize multiprocess and how processes communicating
#History:
#2019/01/21 23:13	Liss	First release
#Try to realize a simpliest scrypt as it was stated.
#perfect





FIFO_FILE=~/bash_script/$$.fifo #temporary fifo file

trap "rm -f $FIFO_FILE;exec 6<&-;exec 6>&-" EXIT
set -eo pipefail

if [[ ! -p $FIFO_FILE ]];then
	mkfifo $FIFO_FILE
fi

exec 6<>$FIFO_FILE

#a sub process do something
while read -u6 LINE
do
	echo "processing in pid [$$] [$LINE]" >> ~/bash_script/log.log
	sleep 5
done &


while read LINE
do
	echo "LINE:$LINE"
	echo $LINE >&6
done

exec 6>&-
exec 6<&-
rm -f $FIFO_FILE
