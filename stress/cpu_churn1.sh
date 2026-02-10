#!/bin/bash

set -e

# A value of 800 start to push things
DIGITS=800

# seq        : create a sequence of 1..100
# xargs
#  -n1       : use only 1 arg per xargs call, so 100 calls are created
#  -P 100    : max_process = 100, ie. 100 parallel processes
seq 1 100 | xargs -n1 -P 100 perl -Mbignum=bpi -le "print bpi($DIGITS)"

