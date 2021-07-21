#!/bin/bash

cd ./rancher-v2.4.10/
./login.sh $1

echo "Load Deployments"
./rancher kubectl -n ethereum-net apply -f ../ethereum-kube.yaml --validate=false

echo "Done"