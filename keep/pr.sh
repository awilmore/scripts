#!/bin/bash

set -e

# Determine branch
BRANCH=$( git rev-parse --abbrev-ref HEAD )

if [ -z "$BRANCH" ]; then
  echo "error: git project not detected"
  exit 1
fi

# Determine project name via git remote
PROJECT=$( git remote -v | grep github | grep fetch | awk '{print $2}' | cut -d':' -f2 | cut -f1 -d'.' )

if [ -z "$PROJECT" ]; then
  echo "error: not a github project"
  exit 1
fi

echo "PR LINK: https://github.com/${PROJECT}/compare/${BRANCH}?expand=1"
