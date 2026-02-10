#!/bin/bash

set -e

CMD="/usr/local/bin/vi -b -d "

if [ $# -lt 2 ]; then
  echo "usage: $0 first_file second_file [third_file]"
  exit 1
fi

$CMD "$@"
