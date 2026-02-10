#!/bin/bash

set -e

CMD=/Applications/SmartSynchronize.app/Contents/MacOS/SmartSynchronize
LOG=/tmp/diff-smartsync.log

if [ $# -lt 2 ]; then
  echo "usage: $0 first_file second_file [third_file]"
  exit 1
fi

echo "Launching smartsynchronize..."

echo `date` >> $LOG
$CMD "$@" >> $LOG 2>&1 &
