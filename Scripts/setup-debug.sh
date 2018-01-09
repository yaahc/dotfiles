#!/bin/bash
set -x;
scp -v ${0%/*}/setup-debug root@${1}:/root/setup-debug
ssh root@${1} bash /root/setup-debug "$2" "$3"
