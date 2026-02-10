#!/bin/bash

set -e

CMD="/Applications/DeltaWalker.app/Contents/MacOS/dw"
LOG=/tmp/diff-deltawalker.log

if [ $# -lt 2 ]; then
  echo "usage: $0 first_file second_file [third_file]"
  exit 1
fi

echo "DeltaWalker comparing files ${@}..."
echo `date` >> $LOG
$CMD "$@" >> $LOG 2>&1 
