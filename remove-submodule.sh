#! /bin/bash

SUBMODULE=$1

if [ "x" == "x$SUBMODULE" ]; then
    echo "You need to specify a submodule to remove"
    exit 1
fi

if [ ! -d $SUBMODULE ]; then
    echo "You need to specify a valid directory to be removed"
    exit 2
fi

git submodule deinit -f -- $SUBMODULE
rm -rf .git/modules/$SUBMODULE
git rm -f $SUBMODULE
