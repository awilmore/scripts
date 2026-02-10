#!/bin/bash

set -e

if [ $# != 1 ]; then
  echo "usage: $0 loop_count"
  exit 1
fi

LOOP="$1"

echo " * Starting loop ..."

A="0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
for power in ` seq $LOOP `; do
  echo -n "."
  A="${A}${A}"
  sleep 2
done

echo
echo " * Done."
