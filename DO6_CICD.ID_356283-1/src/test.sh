#!/bin/bash

set -e

APP=./code-samples/DO

run_test() {
    input=$1
    expected=$2
    output=$($APP "$input" 2>/dev/null || true)

    if [ "$output" == "$expected" ]; then
        echo "Test $input ✅"
    else
        echo "Test $input ❌"
    fi
}

run_test 1 "Learning to Linux"
run_test 2 "Learning to work with Network"
run_test 3 "Learning to Monitoring"
run_test 4 "Learning to extra Monitoring"
run_test 5 "Learning to Docker"
run_test 6 "Learning to CI/CD"
#run_test "" "Bad number of arguments!"
run_test 99 "Bad number!"

