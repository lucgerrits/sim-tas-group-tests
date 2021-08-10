#!/bin/bash

cd ./rancher-v2.4.10/

echo "Load Deployments"
./rancher kubectl create -f ../ethereum-kube.yaml --validate=false

echo "Done"