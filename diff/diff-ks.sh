#!/bin/bash

set -e

CMD=/usr/local/bin/ksdiff
LOG=/tmp/diff-ks.log

if [ $# -lt 2 ]; then
  echo "usage: $0 first_file second_file [third_file]"
  exit 1
fi

echo "Launching ksdiff..."

echo `date` >> $LOG
$CMD "$@" >> $LOG 2>&1 &
