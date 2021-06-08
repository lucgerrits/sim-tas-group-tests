#!/bin/bash

cd ./rancher-v2.4.10/
./login.sh $1

echo "Load Deployments"
./rancher kubectl -n substrate-net apply -f ../substrate-kube.yaml --validate=false

echo "Done"