#/bin/bash


echo "start"

apt update

apt-get install -y git

git clone git@bitbucket.org:lucgerrits/ethereum_sim.git

cd EthereumTestingTool/azure/workspace/transfer/backend/node3/geth/ws_stack/client1/

bash ./createenv.sh

