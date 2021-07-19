//
//A lib to simplify my life with our use case and Substrate
//
import { Keyring } from '@polkadot/keyring';
import axios from 'axios';
// import { ApiPromise, WsProvider } from '@polkadot/api';
import additionalTypes from "../../additional_types.js";
import { createHash, randomBytes } from 'crypto';
import { cryptoWaitReady, mnemonicGenerate } from '@polkadot/util-crypto';
import { readFileSync, existsSync } from 'fs'
const filename = "accounts.json"

//init api
var api = {
    spec: "",
    params: {
        address: "",
        blockHash: "",
        blockNumber: 0,
        genesisHash: "",
        metadataRpc: "",
        specVersion: 0,
        transactionVersion: 0,
        nonce: -1,
        tip: 0,
        eraPeriod: 64, // number of blocks from checkpoint that transaction is valid
    },
};
// init keyring
var keyring;
// init alice and charlie accounts
var alice;
var bob;
var charlie;
var ACCOUNT_PAIRS = [];


async function reqSubstrateHTTPApi(url) {
    try {
        const response = await axios.get(url);
        return response.data;
    } catch (error) {
        console.log(error.message);
        return false;
    }
}

async function getBlockHash(url, block_number) {
    return (await reqSubstrateHTTPApi(url + "/blocks/" + block_number)).value
}
async function getGenesis(url) {
    return await reqSubstrateHTTPApi(url + "/blocks/0");
}
async function getHead(url) {
    return await reqSubstrateHTTPApi(url + "/blocks/head");
}
async function getMetadata(url) {
    return await reqSubstrateHTTPApi(url + "/runtime/metadata");
}
async function getSpec(url) {
    return await reqSubstrateHTTPApi(url + "/runtime/spec");
}

async function get_sudo_keyPair(url) {
    return (await reqSubstrateHTTPApi(url + "/pallets/sudo/storage/key")).value;
}

async function get_factory(url, sudo_key) {
    return (await reqSubstrateHTTPApi(url + "/pallets/simModule/storage/Factories?key1=" + sudo_key)).value;
}

// async function get_cars(api) { //not possible in http
//     let data = await api.query.simModule.cars.keys();
//     let a = data.map(({ args: [carId] }) => carId);
//     return a;
// }

async function get_car(url, car_id) {
    return (await reqSubstrateHTTPApi(url + "/pallets/simModule/storage/Cars?key1=" + car_id)).value;
}

// async function get_crashes(api) { //not possible in http
//     let data = await api.query.simModule.crashes.keys();
//     let a = data.map(({ args: [carId] }) => carId);
//     return a;
// }

async function get_crash(url, car_id) {
    return (await reqSubstrateHTTPApi(url + "/pallets/simModule/storage/Crashes?key1=" + car_id)).value;
}

function getKeyring() {
    return keyring;
}

var substrate_sim = {
    reqSubstrateHTTPApi: reqSubstrateHTTPApi,
    initApi: async function (url) {
        // Construct
        api.spec = await getSpec(url);
        api.params.genesisHash = (await getGenesis(url)).hash;
        api.params.head = (await getHead(url)).hash;
        api.params.metadataRpc = await getMetadata(url);
        api.params.specVersion = parseInt(api.spec.specVersion);
        api.params.transactionVersion = parseInt((await getSpec(url)).transactionVersion);
        await cryptoWaitReady();
        keyring = new Keyring({ type: 'sr25519' });
        // init alice and charlie accounts
        alice = getKeyring().addFromUri('//Alice', { name: 'Alice default' });
        bob = getKeyring().addFromUri('//Bob', { name: 'Bob default' });
        charlie = getKeyring().addFromUri('//Charlie', { name: 'Charlie default' });

        substrate_sim.accounts.makeAll() //init all accounts
        return api;
    },
    accounts: {
        alice: () => { return alice; },
        bob: () => { return bob; },
        charlie: () => { return charlie; },
        genMnemonic: () => {
            return mnemonicGenerate();
        },
        genFromMnemonic: (mnemonic, name) => {
            return getKeyring().addFromUri(mnemonic, { name: name }, 'ed25519');
        },
        makeAll: () => {
            if (existsSync(filename)) {
                var i = 0;
                readFileSync(filename, 'utf-8').split(/\r?\n/).forEach(function (line) {
                    if (line.trim().length > 5) {
                        ACCOUNT_PAIRS.push(substrate_sim.accounts.genFromMnemonic(line, `Account ${i}`))
                        i += 1;
                    }
                })
            } else {
                console.error(`${filename} doesn't exist. Use genAccounts.js to build one.`)
                process.exit(1);
            }
        },
        getAll: () => {
            return ACCOUNT_PAIRS;
        }
    },
    print_factories: async function (url, sudo_key) {
        var factory = await get_factory(url, sudo_key);
        if (factory == 0) {
            console.log(`[+] ${sudo_key} is NOT a factory.`)
            return false;
        } else {
            let factory_blockHash = await getBlockHash(url, factory);
            console.log(`[+] ${sudo_key} is a factory.\n\tAdded in block number: ${factory}\n\tBlock Hash: ${factory_blockHash}"`);
            return true;
        }
    },
    // print_cars: async function (api, expand = false) {
    //     var cars = await get_cars(api);
    //     console.log(`[+] Stored cars: ${Object.keys(cars).length}`);
    //     if (expand) {
    //         for (const [key, car_id] of Object.entries(cars)) {
    //             let car = await get_car(api, car_id);
    //             console.log(`[+] Car: ${car_id}\n\tAdded by: ${car[0]}\n\tJoined on block: ${car[1]}`);
    //         }
    //     }
    // },
    // print_crashes: async function (api) {
    //     var crashes = await get_crashes(api);
    //     console.log(`[+] Stored cars that had crashed at least once: ${Object.keys(crashes).length}`);

    //     for (const [key, car_id] of Object.entries(crashes)) {
    //         let car_crashes = await get_crash(api, car_id);
    //         // console.log(`[+] Car: ${car_id} \n\t${car_crashes}`);
    //         console.log(`[+] Car: ${car_id}`);
    //         console.log(`\t-Total crashes: ${car_crashes.length}`);
    //         for (const crash of car_crashes) {
    //             console.log(`\t\tCrashed at block: ${crash.block_number}`);
    //             console.log(`\t\tData hash ${crash.data}\n`);
    //         }
    //     }
    // },
    print_header: async (url) => {
        // Retrieve the last timestamp
        const now = parseInt((await getHead(url)).extrinsics[0].args.now); //api.query.timestamp.now();
        const now_human = new Date(now).toISOString();
        // Genesis Hash
        const genesisHash = (await getGenesis(url)).hash //api.genesisHash.toHex()
        console.log("---------------------------------------------------------------------------------------------");
        console.log(`[+] Genesis Hash: ${genesisHash}`);
        console.log(`[+] Node time: ${now} (${now_human})`);
        console.log(`[+] Accounts:`);
        console.log(`\t Alice:\t\t${substrate_sim.accounts.alice().address}`);
        console.log(`\t Bob:\t\t${substrate_sim.accounts.bob().address}`);
        console.log(`\t Charlie:\t${substrate_sim.accounts.charlie().address}`);
        console.log(`[+] Auto generated accounts: ${substrate_sim.accounts.getAll().length}`);
        console.log("---------------------------------------------------------------------------------------------");

    },
    send: {
        new_car_crash: async function (api, car, verbose = false) {
            const nonce = await api.rpc.system.accountNextIndex(car.address);

            // var rnd_bytes = randomBytes(32);
            //process.hrtime().toString()
            // var data = "Hello world:" + rnd_bytes.toString("hex");
            var data = "Hello world";
            const hash = createHash('sha256');
            hash.update(data);
            var data_sha256sum = hash.digest();
            // console.log(`Hash "${data}" = ${data_sha256sum.toString("hex")}`)
            // Sign and send a new crash from Bob car
            const tx = await api.tx.simModule
                .storeCrash(data_sha256sum.buffer.toString())
                .signAndSend(car,
                    { nonce: -1 },
                );
            if (verbose)
                console.log(`Transaction sent: ${tx}`);
        },
        new_factory: async function (api, factory) {
            // https://polkadot.js.org/docs/api/start/api.tx.wrap/#sudo-use
            const sudoPair = await get_sudo_keyPair(api);
            const { nonce } = await api.query.system.account(sudoPair.address);
            // console.log(`nonce: ${nonce}`)
            let tx = await api.tx.sudo.sudo(
                api.tx.simModule.storeFactory(factory.address)
            ).signAndSend(sudoPair, { nonce });
            console.log(`Transaction sent: ${tx}`);
            return tx;
        },
        new_car: async function (api, factory, car) {
            let tx = await api.tx.simModule
                .storeCar(car.address)
                .signAndSend(factory,
                    { nonce: -1 },
                );
            console.log(`Transaction sent: ${tx}`);
            return tx;
        },
        // new_owner: async function (api, sudo_account, car) {
        //     // https://polkadot.js.org/docs/api/start/api.tx.wrap/#sudo-use
        //     let tx = await api.tx.sudo(
        //         api.tx.simModule.storeCar(car.address)
        //     ).signAndSend(sudo_account, { nonce: -1 });
        //     console.log(`Transaction sent: ${tx}`);
        // }
    },
    sleep: function (ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
}

export default substrate_sim = substrate_sim