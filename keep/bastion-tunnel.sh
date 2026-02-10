#!/bin/bash

set -e

if [ $# != 1 ]; then
  echo "usage: $0 vm_resource_id"
  exit 1
fi

RID="$1"

echo
echo " * Creating tunnel ..."
echo

#export http_proxy=http://192.168.0.50:8888
#export https_proxy=https://192.168.0.50:8888
#export HTTP_PROXY=http://192.168.0.50:8888
#export HTTPS_PROXY=https://192.168.0.50:8888

export AZURE_CLI_DISABLE_CONNECTION_VERIFICATION=1

az network bastion tunnel \
  --name bastion-live-mx51-aea \
  --resource-group rg-live-mx51-bastion-aea \
  --target-resource-id "$RID" \
  --resource-port 3389 \
  --port 3333
