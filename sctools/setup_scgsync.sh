#! /bin/bash

set -e
set -o xtrace

# shellcheck disable=SC1090
. ~/.scalerc

run_buildvm git config receive.denyCurrentBranch ignore
scp post-receive "$BUILDVM_HOSTNAME:$SRC_ROOT/.git/hooks/"

cd "$GIT_ROOT" || exit 1
git remote add buildvm "ssh://$GIT_USER@$BUILDVM_HOSTNAME:$SRC_ROOT"
