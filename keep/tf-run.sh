#!/bin/bash


###
# NOTE:
# - to run a make plan on tenants against rnd-cde-perf, use:
#   % clear; ec 40; tf-run.sh 813967790104 saml-mx perf/cde/rnd/eks/config make plan
#
# - to run a make plan on shared, use:
#   % clear; ec 40; tf-run.sh 567505611260 mx-admin-tools tools/live/eks/config make plan
###

set -e

if [ $# != 5 ]; then
  echo "usage: $0 account_id profile_name subfolder make plan/apply"
  exit 1
fi

AID="$1"
AWS_PROFILE="$2"
SUBF="$3"
TARGET="$5"

# Set role arn
export TERRAGRUNT_IAM_ROLE="arn:aws:iam::$AID:role/identity-admin"
export TG_IAM_ASSUME_ROLE="arn:aws:iam::$AID:role/identity-admin"

# Set profile
export AWS_PROFILE=$AWS_PROFILE

# For local
export PARALLELISM=1

# True or false?
export TERRAGRUNT_LOCAL=false

# Source secrets
source $HOME/.secrets

# Run command
time SUBFOLDER=$SUBF make $TARGET
