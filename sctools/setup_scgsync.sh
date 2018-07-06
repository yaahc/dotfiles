#! /bin/bash

set -e
set -o xtrace

# shellcheck disable=SC1090
. ~/.scalerc

git remote add buildvm "ssh://$GIT_USER@$BUILDVM_HOSTNAME:$SRC_ROOT"
run_buildvm git config receive.denyCurrentBranch ignore
scp post-receive "$BUILDVM_HOSTNAME:$SRC_ROOT/.git/hooks/"
