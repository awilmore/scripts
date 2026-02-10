#!/bin/bash

set -e

CMD=/Applications/kdiff3.app/Contents/MacOS/kdiff3
LOG=/tmp/diff-kdiff3.log

if [ $# -lt 2 ]; then
  echo "usage: $0 first_file second_file [third_file]"
  exit 1
fi

echo "Launching kdiff3..."

echo `date` >> $LOG
$CMD "$@" >> $LOG 2>&1 &
