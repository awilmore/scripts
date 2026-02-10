#!/bin/bash

set -e

if [ $# != 1 ]; then
  echo "usage: $0 webhook_url"
  exit 1
fi

HOOK="$1"

curl -X POST -H 'Content-type: application/json' --data '{"text":"<@UUT3AEYEB>: Webhook test"}' "$HOOK"

echo
