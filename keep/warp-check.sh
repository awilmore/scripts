#!/bin/bash

set -e

if [ $# != 1 ]; then
  echo "usage: $0 domain"
  exit 1
fi

HOST="$1"
PORT="443"

echo -n | openssl s_client -connect $HOST:$PORT -servername $HOST | openssl x509 -text | grep Issuer


#HOST="tunnel.cloudproxy.app"
#PORT="443"
#echo -n | openssl s_client -connect $HOST:$PORT -servername $HOST | openssl x509 -text | grep Issuer
