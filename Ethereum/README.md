# Ethereum

Folder containing the files required to deploy Ethereum in Kubernetes.


## Before anything !

Make sure current cloud can be deleted: save data if necessary.


Folder structure:

- ./geth/ : all files for Clique consensus
- ./open-ethereum/ : all files for AURA consensus
- ./besu/ : all files for IBFT consensus

Deploy Process:

./delete-ethereum-net.sh RancherToken

./genNodeYaml.sh > ethereum-kube.yaml

./deploy-ethereum.sh RancherToken

