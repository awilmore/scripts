#!/bin/bash

set -e

# how many dots/seconds per line
NL=60

if [ $# != 1 ]; then
  echo "usage: $0 seconds"
  exit 1
fi

SECONDS="$1"

COUNT=0

echo
#echo -n " -> sleeping (${SECONDS}s) "
printf " -> sleeping (%3ss) " $SECONDS

REMAINING="$SECONDS"

for i in `seq 1 $SECONDS`; do
  sleep 1
  echo -n '.'

  # Update count
  COUNT=$((COUNT+1))

  # Check count
  if [ $COUNT -ge $NL ]; then
    REMAINING=$((REMAINING-$NL))
    COUNT=0

    if [ $REMAINING -gt 0 ]; then
      echo
      #echo -n " -> sleeping (${REMAINING}s) "
      printf " -> sleeping (%3ss) " $REMAINING
    fi
  fi
done

echo
echo
