#!/bin/bash

set -e

# The live VMs are in this subscription. Each VM group has these names:
#   resource group: rg-vm-live-<name>-aea
#   Key Vault:      live-pos-vms-<name>
#   secrets:        <vm>-user, and <vm>-pass or password
# Not all VM names are cloud-<name>-1, so the script finds the VM in Azure.
SUBSCRIPTION_ID="879b3461-ae43-432e-a410-1bb755c8115e"

usage() {
  echo "usage: $0 <vm_resource_id | name>"
  echo
  echo "examples:"
  echo "  $0 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-vm-live-pay4-aea/providers/Microsoft.Compute/virtualMachines/cloud-pay4-1"
  echo "  $0 pay4"
  exit 1
}

# Copy stdin to the clipboard. Return 1 if no clipboard tool is available.
to_clipboard() {
  if command -v pbcopy &> /dev/null; then
    pbcopy
  elif command -v wl-copy &> /dev/null; then
    wl-copy
  elif command -v xclip &> /dev/null; then
    xclip -selection clipboard
  else
    return 1
  fi
}

if [ $# != 1 ]; then
  usage
fi

ARG="$1"

# If the argument is a full resource ID, use it as it is.
# If not, find the VMs in the resource group of the short name.
if [[ "$ARG" == /subscriptions/* ]]; then
  RID="$ARG"
elif [[ "$ARG" =~ ^[a-z0-9]+$ ]]; then
  RG="rg-vm-live-$ARG-aea"
  echo " * Finding the VM in $RG ..."
  IDS=$(az vm list --subscription "$SUBSCRIPTION_ID" -g "$RG" --query '[].id' -o tsv 2> /dev/null || true)
  if [ -z "$IDS" ]; then
    echo "error: no VM found in resource group $RG"
    exit 1
  fi
  if [ "$(echo "$IDS" | wc -l)" -eq 1 ]; then
    RID="$IDS"
  else
    # If the group has two or more VMs, ask the user to select one.
    echo
    PS3="Select a VM: "
    select VM in $(echo "$IDS" | sed 's#.*/##'); do
      if [ -n "$VM" ]; then
        RID=$(echo "$IDS" | grep "/$VM\$")
        break
      fi
    done
  fi
else
  echo "error: '$ARG' is not a resource ID or a short VM name (for example: pay4)"
  echo
  usage
fi

# Get the VM name and the short name from the resource ID.
# The resource group in the ID can be in uppercase.
VM_NAME="${RID##*/}"
RG_NAME=$(echo "$RID" | sed -E 's#.*/resource[Gg]roups/([^/]+)/.*#\1#' | tr '[:upper:]' '[:lower:]')
SHORT_NAME=$(echo "$RG_NAME" | sed -E 's#^rg-vm-live-(.+)-aea$#\1#')
VAULT="live-pos-vms-$SHORT_NAME"

echo
echo " * VM:    $VM_NAME"
echo " * ID:    $RID"

# Get the login from Key Vault. If this fails, show a warning and open the tunnel anyway.
# Do not print the password. Copy it to the clipboard only.
VM_USER=$(az keyvault secret show --vault-name "$VAULT" --name "$VM_NAME-user" --query value -o tsv 2> /dev/null || true)
VM_PASS=$(az keyvault secret show --vault-name "$VAULT" --name "$VM_NAME-pass" --query value -o tsv 2> /dev/null || true)
if [ -z "$VM_PASS" ]; then
  # Some vaults use the name password.
  VM_PASS=$(az keyvault secret show --vault-name "$VAULT" --name "password" --query value -o tsv 2> /dev/null || true)
fi

if [ -n "$VM_USER" ]; then
  echo " * User:  $VM_USER"
else
  echo " * Warning: cannot read secret $VM_NAME-user from Key Vault $VAULT"
fi

if [ -z "$VM_PASS" ]; then
  echo " * Warning: cannot read secret $VM_NAME-pass or password from Key Vault $VAULT"
elif printf '%s' "$VM_PASS" | to_clipboard; then
  echo " * Pass:  copied to the clipboard"
else
  echo " * Warning: no clipboard tool found (pbcopy, wl-copy or xclip), so the password is not shown"
fi
unset VM_PASS

echo
echo " * Creating tunnel on localhost:3333 ..."
echo

#export http_proxy=http://192.168.0.50:8888
#export https_proxy=https://192.168.0.50:8888
#export HTTP_PROXY=http://192.168.0.50:8888
#export HTTPS_PROXY=https://192.168.0.50:8888

# Set this variable only for the tunnel call, not for the Key Vault calls.
AZURE_CLI_DISABLE_CONNECTION_VERIFICATION=1 az network bastion tunnel \
  --name bastion-live-mx51-aea \
  --resource-group rg-live-mx51-bastion-aea \
  --target-resource-id "$RID" \
  --resource-port 3389 \
  --port 3333
