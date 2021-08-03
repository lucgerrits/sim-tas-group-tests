#!/bin/bash

#RUN example:
#
#./big_test.sh <RANCHER TOKEN> > test-"`date +"%Y-%m-%d-%T"`".log
#

GRAFANA_URL="http://grafana.unice.cust.tasfrance.com/api/annotations"
GRAFANA_DASHBOARD_ID="3"

JS_THREADS=20

#key=tps
#we want an avg of 1 min test, ie 60 * tps
# arr_tests=(100 500 800 1000 1100 1300 1500)
arr_tests_nodes=(4 6 12 18 24)
# arr_tests_tps=(1000 1100 1200 1300 1400 1500 1600)
arr_tests_tps=(500 800 1000 1200)
tot_cars=10000
tot_factories=10

function send_annotation {
    curl -s -H "Content-Type: application/json" \
        -X POST \
        -u admin:admin1234  \
        -d "{\"tags\":[\"tests\", \"$5\"], \"dashboardId\":$GRAFANA_DASHBOARD_ID, \"text\":\"nodes=$4,tps=$1,total=$2,test=$3,cars=$tot_cars,factories=$tot_factories,threads=$JS_THREADS\"}" \
        $GRAFANA_URL
    echo ""
}

for nb_nodes in "${arr_tests_nodes[@]}"; do

    for tps in "${arr_tests_tps[@]}"; do
        
        total_tx=100000 #$(($tps * 60))

        send_annotation "${tps}" "$total_tx" "${i}" "$(($nb_nodes -1))" "init_network"

        cd ../cloud-deployments
        ./delete-substrate-net.sh $1
        sleep 10
        ./genNodeYaml.sh $nb_nodes > substrate-kube.yaml
        ./deploy-substrate.sh $1
        sleep 180

        send_annotation "${tps}" "$total_tx" "${i}" "$(($nb_nodes -1))" "end_init_network"

        cd ../remote-access-benchmark

        for i in {1..10}; do #repeat 5 times the test

            echo "################### TEST tps=$tps n°$i #######################";

            send_annotation "${tps}" "$total_tx" "${i}" "$(($nb_nodes -1))" "init_tx"

            echo "generate identities cars=$tot_cars factories=$tot_factories"
            ./cmd_remote.sh "./bin/genAccounts.js $tot_cars $tot_factories" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" #sed to remove colors

            echo "send init identities"
            ./cmd_remote.sh "./bin/ws/init_v2.js" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"

            send_annotation "${tps}" "$total_tx" "${i}" "$(($nb_nodes -1))" "end_init_tx"

            sleep 20 #wait finalisation

            send_annotation "${tps}" "$total_tx" "${i}" "$(($nb_nodes -1))" "send_tx"

            echo "send tx"
            ./cmd_remote.sh "./bin/ws/send_v2.js $total_tx $tps $JS_THREADS" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"

            send_annotation "${tps}" "$total_tx" "${i}" "$(($nb_nodes -1))" "end_send_tx"

            sleep 30

            echo "################### END TEST n°$i #######################"

            sleep 300
        done

    done

done