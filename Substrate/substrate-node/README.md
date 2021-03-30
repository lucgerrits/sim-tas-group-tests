# Substrate Node Template

This is a substrate node template with an added pallet [SIM](./pallets/sim).

Everything should run in docker/docker-compose.

## Installation 

You'll have to install the SIM pallet to be able to use it.

```bash
#go to git root: cd <SOME PATH>/SIM-TAS-Group-tests
git submodule update --init --recursive
cd Substrate/substrate-node
cp -r additional-pallets/sim/ substrate-node-template/pallets/
```

Add code in `./substrate-node-template/runtime/src/lib.rs` :
```diff
/// Configure the template pallet in pallets/template.
impl pallet_template::Config for Runtime {
	type Event = Event;
}

+impl pallet_sim::Config for Runtime {
+	type Event = Event;
+}

// Create the runtime by composing the FRAME pallets that were previously configured.
construct_runtime!(
	pub enum Runtime where
		Block = Block,
		NodeBlock = opaque::Block,
		UncheckedExtrinsic = UncheckedExtrinsic
	{
		System: frame_system::{Module, Call, Config, Storage, Event<T>},
		RandomnessCollectiveFlip: pallet_randomness_collective_flip::{Module, Call, Storage},
		Timestamp: pallet_timestamp::{Module, Call, Storage, Inherent},
		Aura: pallet_aura::{Module, Config<T>},
		Grandpa: pallet_grandpa::{Module, Call, Storage, Config, Event},
		Balances: pallet_balances::{Module, Call, Storage, Config<T>, Event<T>},
		TransactionPayment: pallet_transaction_payment::{Module, Storage},
		Sudo: pallet_sudo::{Module, Call, Config<T>, Storage, Event<T>},
		// Include the custom logic from the template pallet in the runtime.
		TemplateModule: pallet_template::{Module, Call, Storage, Event<T>},
+		SimModule: pallet_sim::{Module, Call, Storage, Event<T>},
	}
);
```

Add code in `./substrate-node-template/runtime/Cargo.toml` :
```diff
# local dependencies
pallet-template = { path = '../pallets/template', default-features = false, version = '3.0.0' }
+pallet-sim = { path = '../pallets/sim', default-features = false, version = '3.0.0' }
```



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