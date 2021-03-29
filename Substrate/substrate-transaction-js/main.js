
// Import
import { ApiPromise, WsProvider } from '@polkadot/api';
import { Keyring } from '@polkadot/keyring';
import additionalTypes from "./additional_types.js";
import { createHash } from 'crypto';


const url = "ws://127.0.0.1:9944";

async function get_balance(api, address) {
    let { data: balance } = await api.query.system.account(address);
    return balance.free.toBigInt();
}

async function get_sudo_key(api) {
    let key = await api.query.sudo.key();
    return key.toString();
}

async function get_factory(api, sudo_key) {
    let data = await api.query.simModule.factories(sudo_key);
    return data;
}

async function get_cars(api) {
    let data = await api.query.simModule.cars.keys();
    let a = data.map(({ args: [carId] }) => carId);
    return a;
}

async function get_car(api, car_id) {
    let data = await api.query.simModule.cars(car_id);
    return data;
}

async function get_crashes(api) {
    let data = await api.query.simModule.crashes.keys();
    let a = data.map(({ args: [carId] }) => carId);
    return a;
}

async function get_crash(api, car_id) {
    let data = await api.query.simModule.crashes(car_id);
    return data;
}

async function print_factories(api, sudo_key) {
    var factory = await get_factory(api, sudo_key);
    if (factory.words && factory.words[0] == 0) {
        console.log(`[+] ${sudo_key} is not a factory.`)
        return false;
    } else {
        let factory_blockHash = await api.rpc.chain.getBlockHash(factory.words[0]);
        console.log(`[+] ${sudo_key} is a factory.\n\tAdded in block number: ${factory.words[0]}\n\tBlock Hash: ${factory_blockHash}"`);
        return true;
    }
}

async function print_cars(api) {
    var cars = await get_cars(api);
    console.log(`[+] Stored cars: ${Object.keys(cars).length}`);

    for (const [key, car_id] of Object.entries(cars)) {
        let car = await get_car(api, car_id);
        console.log(`[+] Car: ${car_id}\n\tAdded by: ${car[0]}\n\tJoined on block: ${car[1]}`);
    }
}
async function print_crashes(api) {
    var crashes = await get_crashes(api);
    console.log(`[+] Stored cars that had crashed at least once: ${Object.keys(crashes).length}`);

    for (const [key, car_id] of Object.entries(crashes)) {
        let car_crashes = await get_crash(api, car_id);
        // console.log(`[+] Car: ${car_id} \n\t${car_crashes}`);
        console.log(`[+] Car: ${car_id}`);
        console.log(`\t-Total crashes: ${car_crashes.length}`);
        for (const crash of car_crashes) {
            console.log(`\t\tCrashed at block: ${crash.block_number}`);
            console.log(`\t\tData hash ${crash.data}\n`);
        }
    }
}


async function main() {
    // Construct
    const wsProvider = new WsProvider(url);
    const api = await ApiPromise.create({ provider: wsProvider, types: additionalTypes });
    // Retrieve the last timestamp
    const now = await api.query.timestamp.now();
    // Genesis Hash
    const genesisHash = api.genesisHash.toHex()
    // init keyring
    const keyring = new Keyring({ type: 'sr25519' });
    // init alice and charlie accounts
    const alice = keyring.addFromUri('//Alice', { name: 'Alice default' });
    const bob = keyring.addFromUri('//Bob', { name: 'Bob default' });
    const charlie = keyring.addFromUri('//Charlie', { name: 'Charlie default' });

    console.log("---------------------------------------------------------------------------------------------");
    console.log(`[+] Genesis Hash: ${genesisHash}`);
    console.log(`[+] Node time: ${now}`);
    console.log(`[+] Accounts:`);
    console.log(`\t Alice:\t\t${alice.address}`);
    console.log(`\t Bob:\t\t${bob.address}`);
    console.log(`\t Charlie:\t${charlie.address}`);
    console.log("---------------------------------------------------------------------------------------------");



    // print alice and charlie balance
    var balance = await get_balance(api, alice.address);
    console.log(`[+] Alice balance: ${balance.toString()}`);
    balance = await get_balance(api, charlie.address);
    console.log(`[+] Charlie balance: ${balance.toString()}`);

    // print sudo account address
    var sudo_key = await get_sudo_key(api);
    console.log(`[+] Sudo key: ${sudo_key}`);

    // print sudo factories
    // Note: from here on consider that alice is a factory (i.e. factory_key = sudo_key)
    var is_factory = print_factories(api, sudo_key);
    if (!is_factory) {
        //TODO: Add as a factory if not
    }

    await print_cars(api);
    await print_crashes(api);

    var data = now.toString() + ":Hello world";
    const hash = createHash('sha256');
    hash.update(data);
    var data_sha256sum = hash.digest();
    console.log(`Hash "${data}" = ${data_sha256sum.toString("hex")}`)


    // Sign and send a new crash from Bob car
    const unsub = await api.tx.simModule
        .storeCrash(data_sha256sum.buffer)
        .signAndSend(bob, ({ events = [], status }) => {
            console.log(`Current status is ${status.type}`);

            if (status.isFinalized) {
                console.log(`Transaction included at blockHash ${status.asFinalized}`);

                // Loop through Vec<EventRecord> to display all events
                events.forEach(({ phase, event: { data, method, section } }) => {
                    console.log(`\t' ${phase}: ${section}.${method}:: ${data}`);
                });
                unsub();
            }
        });
}

main().catch(console.error).finally(() => process.exit());