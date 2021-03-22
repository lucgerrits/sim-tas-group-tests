# Substrate Node Template

This is a substrate node template with an added pallet [SIM](./pallets/sim).

Everything should run in docker/docker-compose.

## Docker compose

### Local 1 node setup

Use the [docker-compose.yml](./docker-compose.yml) to run a local dev node.

### Local N node setup

Use the [docker-compose-aura.yml](./docker-compose-aura.yml) to run a substrate network of N nodes.

The docker compose file contains:
- **Substrate Genesis:** definition of genesis configuration and start the first validator in a chain mode (local), using an account (alice), and a node key.
- **Substrate Peer:** definition of a peer that will boot using the genesis validator information
→This node can be scaled to N !
- **Metrics docker:** Database (Prometheus), stats interface (grafana), app
interface (template frontend)


## Interfaces


- **Node template interface:** http://127.0.0.1:8000
- **General Substrate blockchain interface:**
https://polkadot.js.org/apps/#/settings?rpc=ws://127.0.0.1:9944
- **Grafana:** http://127.0.0.1:3000

## Docker issue fix tips:
```
sudo chown 472 -R grafana-data/

sudo chown <user> -R prometheus
```