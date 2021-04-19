#!/bin/bash

rm -r ./datas_csv/*

echo "6_nodes"
./export_influxdb_data.sh 1618648510089 1618662753248
./build_data.py "5tps|6_nodes"

./export_influxdb_data.sh 1618662934316 1618671949158
./build_data.py "10tps|6_nodes"

./export_influxdb_data.sh 1618672104227 1618678876449
./build_data.py "20tps|6_nodes"

echo "12_nodes"
./export_influxdb_data.sh 1618781571866 1618795969900
./build_data.py "5tps|12_nodes"

./export_influxdb_data.sh 1618796191242 1618805497211
./build_data.py "10tps|12_nodes"

./export_influxdb_data.sh 1618805807010 1618812658269
./build_data.py "20tps|12_nodes"

echo "18_nodes"
echo "TODO"

echo "24_nodes"
echo "TODO"
