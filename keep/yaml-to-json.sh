#!/bin/bash

set -e

if [ $# != 1 ]; then
  echo "usage: $0 yaml_file"
  exit 1
fi

YAML_FILE="$1"

YQ=$( which yq )
JQ=$( which jq )

if [ -z "$YQ" ]; then
  echo "error: yq command not found (try 'brew install yq')"
  exit 1
fi

if [ -z "$JQ" ]; then
  echo "error: jq command not found"
  exit 1
fi

yq r -j "$YAML_FILE" | jq .
