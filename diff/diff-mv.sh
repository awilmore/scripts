#!/bin/bash

set -e

CMD="/usr/local/bin/gvim -b -d "
LOG=/tmp/diff-macvim.log

if [ $# -lt 2 ]; then
  echo "usage: $0 first_file second_file [third_file]"
  exit 1
fi

echo "Launching macvim..."

echo `date` >> $LOG
$CMD "$@" >> $LOG 2>&1 &
