#!/bin/bash

set -e

CMD=/usr/bin/opendiff
LOG=/tmp/diff-filemerge.log

if [ $# -lt 2 ]; then
  echo "usage: $0 first_file second_file [third_file]"
  exit 1
fi

echo "Launching filemerge..."

echo `date` >> $LOG
#$CMD "$@" >> $LOG 2>&1 
$CMD "$@" >> $LOG 
