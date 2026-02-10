#!/bin/bash

set -e

if [ $# != 1 ]; then
  echo "usage: $0 node_name"
  exit 1
fi

NODE="$1"

kubectl cordon $NODE
