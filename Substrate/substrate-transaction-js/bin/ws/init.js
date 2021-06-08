#!/usr/bin/env node

import substrate_sim from "../../src/ws/substrate_sim_lib.js";

if (process.argv.length <= 2) {
    console.error("Required 2 argument: \n\tSend new factory: true/false.\n\tSend new car: true/false")
    process.exit(1);
}
// const url = "ws://127.0.0.1:9944";
const url = "ws://substrate-ws.unice.cust.tasfrance.com";

async function main() {
    console.log("Start init.js...")
    var api = await substrate_sim.initApi(url);

    await substrate_sim.print_header(api);
    console.log("Continue in 2s ...");
    await substrate_sim.sleep(1000); //wait a little

    // // print alice and charlie balance
    // var balance = await get_balance(api, alice.address);
    // console.log(`[+] Alice balance: ${balance.toString()}`);
    // balance = await get_balance(api, charlie.address);
    // console.log(`[+] Charlie balance: ${balance.toString()}`);

    var already_factory = await substrate_sim.print_factories(api, substrate_sim.accounts.alice().address);
    await substrate_sim.print_cars(api);
    // await print_crashes(api);

    console.log("Send new factory...")
    if (process.argv[2] == "true") {
        // console.log(`Add factory:\t ${substrate_sim.accounts.alice().address}`)
        try {
            if (already_factory) {
                console.log(`Already factory:\t ${substrate_sim.accounts.alice().address}`)
            } else {
                await substrate_sim.send.new_factory(api, substrate_sim.accounts.alice()); //alice is factory
            }
        } catch (e) {
            console.log("Init factory failed. Maybe already there or concurrent process already send it.")
            console.log(e)
        }
    }

    const car_array = substrate_sim.accounts.getAll();
    if (process.argv[3] == "true") {
        console.log("Send new cars...")
        await substrate_sim.sleep(2000); //wait a little
        for (let i = 0; i < car_array.length; i++) {
            // console.log(`Add car:\t ${car_array[i].address}`)
            try {
                await substrate_sim.send.new_car(api, substrate_sim.accounts.alice(), car_array[i]); //add car_array[i] as a car
                process.stdout.write(".");
                await substrate_sim.sleep(20); //wait a little: get error "tx outdated" when one account sends too many tx/sec
                if (i % 100 == 0)
                    console.log(`\n${(i*100)/car_array.length}%`)
            } catch (e) {
                console.log(e)
            }
        }
        console.log("")
    }
    console.log("Done")
}

main().catch(console.error).finally(() => process.exit(0));