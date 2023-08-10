#! /bin/bash

TEMP_INDEX=$(mktemp) || exit 1

cp .git/index $TEMP_INDEX
GIT_INDEX_FILE=$TEMP_INDEX git add -u .
echo "temp commit" | git commit-tree $(GIT_INDEX_FILE=$TEMP_INDEX git write-tree) -p HEAD

rm $TEMP_INDEX
