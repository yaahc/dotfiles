#!/bin/bash

runQuery "select build_id,testsuite_result_id from test_failure_detail where comment LIKE 'JL%' and reviewed = 0 order by end_time desc" \
    | awk '{print "http://releaseengineering.lab.local/builds/automated/" $1 "/logs/test/" $2"/"}' \
    | xargs -n1 -i pulllogs.sh {}
