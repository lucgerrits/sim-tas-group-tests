#!/bin/bash

cd ./rancher-v2.4.10/
./login.sh $1

echo "Load Deployments"
./rancher kubectl -n monitoring apply -f $2 --validate=false

echo "Done"