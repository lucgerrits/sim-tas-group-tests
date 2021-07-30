#!/bin/bash
cd ./rancher-v2.4.10/

./rancher kubectl delete -f ../ethereum-kube.yaml --force

echo "Done"