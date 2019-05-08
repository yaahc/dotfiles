#! /bin/bash
set -e

testbed=st15b
testname=ClusterReset
grindfile="~/grinding"

touch "$grindfile"

function delete_vms() {
    tb "$testbed" "sc vm show | tail -n +3 | awk '{print \$1}' | xargs -n1 sc vm stop uuid"
    tb "$testbed" "sc vm show | tail -n +3 | awk '{print \$1}' | xargs -n1 sc vm delete uuid"
}

function beep() {
    tput bel
}

while [ -f "$grindfile" ]; do
    sctest scqad "$testname" -t "$testbed"
done

beep

while [ -f "$grindfile" ]; do
    sleep 10
    beep
done
