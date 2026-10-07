#!/bin/bash

set -e

# The live VMs use this subscription and these name patterns:
#   resource group: rg-vm-live-<name>-aea
#   VM:             cloud-<name>-1
SUBSCRIPTION_ID="879b3461-ae43-432e-a410-1bb755c8115e"

usage() {
  echo "usage: $0 <vm_resource_id | vm_name>"
  echo
  echo "examples:"
  echo "  $0 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-vm-live-pay4-aea/providers/Microsoft.Compute/virtualMachines/cloud-pay4-1"
  echo "  $0 pay4"
  exit 1
}

if [ $# != 1 ]; then
  usage
fi

ARG="$1"

# If the argument is a full resource ID, use it as it is.
# If not, make the resource ID from the short VM name.
if [[ "$ARG" == /subscriptions/* ]]; then
  RID="$ARG"
elif [[ "$ARG" =~ ^[a-z0-9]+$ ]]; then
  RID="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-vm-live-$ARG-aea/providers/Microsoft.Compute/virtualMachines/cloud-$ARG-1"
else
  echo "error: '$ARG' is not a resource ID or a short VM name (for example: pay4)"
  echo
  usage
fi

echo
echo " * Creating tunnel to: $RID"
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
