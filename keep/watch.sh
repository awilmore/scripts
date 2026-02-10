#!/bin/bash

set -e

if [ $# != 2 ]; then
  echo "usage: $0 interval command"
  exit 1
fi

INTERVAL=$1
COMMAND=$2

while :;
do
  clear;
  OUTPUT=$( $COMMAND )
  echo "`date`  - COMMAND: $COMMAND"
  echo $OUTPUT
  sleep $INTERVAL
done

