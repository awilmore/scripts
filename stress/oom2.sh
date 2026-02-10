#!/bin/bash

# TAGS: mem memory load churn OOM

set -e

if [ $# != 1 ]; then
  echo "usage: $0 loop_count"
  exit 1
fi

LOOP="$1"

echo " * Don't do this :disappointed: "
exit

echo " * Starting loop ..."

for i in `seq 1 $LOOP`; do tail /dev/zero 2>&1 & done

echo " * Done."
