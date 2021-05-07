#!/usr/bin/env node

import substrate_sim from "../src/substrate_sim_lib.js";

if (process.argv.length <= 2) {
    console.error("Required 2 argument: \n\tSend new factory: true/false.\n\tSend new car: true/false")
    process.exit(1);
}

async function main() {
    console.log("Start init.js...")
    var api = await substrate_sim.initApi("ws://10.1.0.222:9944");

    await substrate_sim.print_header(api);
    console.log("Continue in 2s ...");
    await substrate_sim.sleep(2000); //wait a little

    // // print alice and charlie balance
    // var balance = await get_balance(api, alice.address);
    // console.log(`[+] Alice balance: ${balance.toString()}`);
    // balance = await get_balance(api, charlie.address);
    // console.log(`[+] Charlie balance: ${balance.toString()}`);

    await substrate_sim.print_factories(api, substrate_sim.accounts.alice().address);
    await substrate_sim.print_cars(api);
    // await print_crashes(api);

    console.log("Send new factory...")
    if (process.argv[2] == "true") {
        // console.log(`Add factory:\t ${substrate_sim.accounts.alice().address}`)
        try {
            await substrate_sim.send.new_factory(api, substrate_sim.accounts.alice()); //alice is factory
        } catch (e) {
            console.log("Init factory failed. Maybe already there or concurrent process already send it.")
        }
    }
    await substrate_sim.sleep(2000); //wait a little

    console.log("Send new cars...")
    const car_array = substrate_sim.accounts.getAll();
    if (process.argv[3] == "true") {
        for (let i = 0; i < car_array.length; i++) {
            // console.log(`Add car:\t ${car_array[i].address}`)
            await substrate_sim.send.new_car(api, substrate_sim.accounts.alice(), car_array[i]); //add car_array[i] as a car
        }
    }
    console.log("Done")
}

main().catch(console.error).finally(() => process.exit(0));