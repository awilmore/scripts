#!/bin/bash

set -e

if [ $# != 1 ]; then
  echo "usage: $0 cert_file_path"
  exit 1
fi

openssl x509 -in $1 -text | grep 'Not Before\|Not After\|Subject: CN'
