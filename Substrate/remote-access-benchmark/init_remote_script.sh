#/bin/bash

echo "start"

echo "generate identities"
./bin/genAccounts.js 20000 10
echo "send init  identities"
./bin/ws/init_v2.js

echo "Done"