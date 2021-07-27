#!/bin/bash

#RUN example:
#
#./big_test.sh  > test-"`date +"%Y-%m-%d-%T"`".log
#

GRAFANA_URL="http://grafana.unice.cust.tasfrance.com/api/annotations"
GRAFANA_DASHBOARD_ID="3"

JS_THREADS=20

#key=tps
#we want an avg of 1 min test, ie 60 * tps
# arr_tests=(100 500 800 1000 1100 1300 1500)
arr_tests=(900 1000 1100 1200 1300 1400 1500 1600)
tot_cars=10000
tot_factories=10

function send_annotation {
    curl -s -H "Content-Type: application/json" \
        -X POST \
        -u admin:admin1234  \
        -d "{\"tags\":[\"tests\"], \"dashboardId\":$GRAFANA_DASHBOARD_ID, \"text\":\"tps=$1,total=$2,test=$3,cars=$tot_cars,factories=$tot_factories,threads=$JS_THREADS\"}" \
        $GRAFANA_URL
    echo ""
}

for tps in "${arr_tests[@]}"; do

    for i in {1..5}; do #repeat 5 times the test

        total_tx=$(($tps * 60))
        echo "################### TEST tps=$tps n°$i #######################";

        send_annotation ${tps} $total_tx ${i}

        echo "generate identities cars=$tot_cars factories=$tot_factories"
        ./cmd_remote.sh "./bin/genAccounts.js $tot_cars $tot_factories" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"

        echo "send init identities"
        ./cmd_remote.sh "./bin/ws/init_v2.js" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"

        sleep 20 #wait finalisation

        ./cmd_remote.sh "./bin/ws/send_v2.js $total_tx $tps $JS_THREADS" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"

        echo "################### END TEST n°$i #######################"

        sleep 300
    done

done