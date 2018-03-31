#! /bin/bash

cd ~/git/scale-product || exit 1

awk '{ print $NF }' <"$1" | while IFS= read -r line; do
    filename=$(echo "$line" | awk -F":" '{ print $1 }')
    linenumber=$(echo "$line" | awk -F":" '{ print $2 }')
    absolute_filename=$(find . -type f -name "$filename")
    if [ -f "$absolute_filename" ]; then
        blame=$(git --no-pager blame -L "$linenumber,$linenumber" "$absolute_filename")
        echo "$line\` $blame"
    fi
done
