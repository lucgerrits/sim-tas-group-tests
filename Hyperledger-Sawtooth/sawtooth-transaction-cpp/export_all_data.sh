#!/bin/bash
echo "Remove previous results"
rm -r ./datas_csv/*

echo "Start compiling all results"

echo "6_nodes"
./export_influxdb_data.sh 1618648510089 1618662753248 #start end timestamps (13 digits)
./build_data.py "5tps|6_nodes" #name the test

./export_influxdb_data.sh 1618662934316 1618671949158
./build_data.py "10tps|6_nodes"

./export_influxdb_data.sh 1618672104227 1618678876449
./build_data.py "17tps|6_nodes"

./export_influxdb_data.sh 1618914242555 1618915137266
./build_data.py "20tps|6_nodes"

./export_influxdb_data.sh 1618915318532 1618916041273
./build_data.py "25tps|6_nodes"

#max_batches_per_block=1200
./export_influxdb_data.sh 1618928118662 1618930060338
./build_data.py "40tps|6_nodes|bpb_1200|bpd=1k"

#max_batches_per_block=500
./export_influxdb_data.sh 1618932582700 1618933251701
./build_data.py "40tps|6_nodes|bpb_500|bpd=1k"

#max_batches_per_block=500
#block_publishing_delay=200
./export_influxdb_data.sh 1618933586200 1618934255201
./build_data.py "40tps|6_nodes|bpb_500|bpd=200"

echo "12_nodes"
./export_influxdb_data.sh 1618781571866 1618795969900
./build_data.py "5tps|12_nodes"

./export_influxdb_data.sh 1618796191242 1618805497211
./build_data.py "10tps|12_nodes"

./export_influxdb_data.sh 1618805807010 1618812658269
./build_data.py "20tps|12_nodes"

echo "18_nodes"
./export_influxdb_data.sh 1618946501490 1618957272765
./build_data.py "5tps|18_nodes"

./export_influxdb_data.sh 1618960306976 1618968577377
./build_data.py "10tps|18_nodes"

./export_influxdb_data.sh 1618968799807 1618974623463
./build_data.py "20tps|18_nodes"

echo "24_nodes"
echo "TODO"


echo "End compiling all results"