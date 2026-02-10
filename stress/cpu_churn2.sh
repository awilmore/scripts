#!/bin/sh

if [ $# != 1 ]; then
  echo "usage: $0 digits"
  exit 1
fi

DIGITS="$1"

echo
echo " * Starting ..."
echo

# 3 processes
echo "scale=$DIGITS; 4*a(1)" | bc -l &

sleep 1
echo "scale=$DIGITS; 4*a(1)" | bc -l &

sleep 1
echo "scale=$DIGITS; 4*a(1)" | bc -l

echo
echo " * Done."
echo
