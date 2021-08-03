#!/bin/bash
cd ./rancher-v2.4.10/

#$1 is the rancher login token

./login.sh $1

echo "Delete Deployments"
./rancher kubectl -n ethereum-net delete deployments --all

echo "Delete statefulsets"
./rancher kubectl -n ethereum-net delete statefulsets --all

echo "Delete daemonset"
./rancher kubectl -n ethereum-net delete daemonset --all

echo "Delete PVC"
./rancher kubectl -n ethereum-net delete pvc --all

echo "Delete PV"

./rancher kubectl -n ethereum-net get pv | awk '/ethereum-/{print $1}' | xargs ./rancher kubectl -n ethereum-net delete pv

echo "Delete Services"
./rancher kubectl -n ethereum-net delete services --all

echo "Delete ConfigMaps"
./rancher kubectl -n ethereum-net delete configmaps --all

# ./rancher kubectl -n ethereum-net delete pv --all

echo "Done"