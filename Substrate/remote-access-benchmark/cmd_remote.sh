#!/bin/bash
cd ./rancher-v2.4.10/

# echo "CMD: $1"
# echo "###################################################"

./rancher kubectl exec -it -n substrate-net $(./rancher kubectl -n substrate-net get pods | awk '/benchmark-/{printf $1}') -- bash -c "$1"

