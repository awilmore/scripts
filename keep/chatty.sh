#!/bin/bash

WHOISIT=not_sure

if [ $# == 1 ]; then
  WHOISIT=$1
fi

while true; do
  R=$(( ( RANDOM % 30 )  + 11 ))
  printf "%16s : $R s\n" $WHOISIT
  sleep $R
done
