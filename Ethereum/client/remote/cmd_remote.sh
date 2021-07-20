#!/bin/bash
cd ./rancher-v2.4.10/

# echo "CMD: $1"
# echo "###################################################"

./rancher kubectl exec -it -n ethereum-net $(./rancher kubectl -n ethereum-net get pods | awk '/ubuntu-/{printf $1}') -- bash -c "$1"

