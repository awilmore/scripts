#!/bin/bash

set -e

CMD="/usr/local/bin/bcomp -ro "
LOG=/tmp/diff-bc4.log

if [ $# -lt 2 ]; then
  echo "usage: $0 first_file second_file [third_file]"
  exit 1
fi

echo "Launching beyond compare..."

echo `date` >> $LOG
$CMD "$@" >> $LOG 2>&1 
