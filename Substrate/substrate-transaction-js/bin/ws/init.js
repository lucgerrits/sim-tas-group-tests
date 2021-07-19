#!/usr/bin/env node

import substrate_sim from "../../src/ws/substrate_sim_lib.js";
import * as async from "async";

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
    // await print_crashes(api);
    const factory_array = substrate_sim.accounts.getAllFactories();
    const car_array = substrate_sim.accounts.getAllAccounts();

    if (process.argv[2] == "true") {
        console.log("Send new factory...")
        await substrate_sim.sleep(2000); //wait a little

        for (let i = 0; i < factory_array.length; i++) {
            var already_factory = await substrate_sim.print_factories(api, factory_array[i].address);
            try {
                if (already_factory) {
                    console.log(`Already factory:\t ${factory_array[i].address}`)
                } else {
                    await substrate_sim.send.new_factory(api, factory_array[i]); //alice is factory
                    await substrate_sim.sleep(500); //wait a little: get error "tx outdated" when one account sends too many tx/sec
                }
            } catch (e) {
                console.log("Init factory failed. Maybe already there or concurrent process already send it.")
                console.log(e)
            }
        }
        console.log("Wait block finalised")
        await substrate_sim.sleep(18000); //wait block finalised
    }

    if (process.argv[3] == "true") {
        console.log("Send new cars...")
        await substrate_sim.sleep(2000); //wait a little
        for (let i = 0; i < car_array.length; i += factory_array.length) {
            // console.log(`Add car:\t ${car_array[i].address}`)
            var arr = [];
            for (let j = 0; j < factory_array.length; j++) {
                arr.push(substrate_sim.send.new_car(api, factory_array[j], car_array[i + j])) //add car_array[i] as a car
            }

            try {
                //round robin factories to remove outdated issue - thus faster init because we can remove sleep
                await Promise.all(arr);
                // await substrate_sim.send.new_car(api, factory_array[i % factory_array.length], car_array[i]); //add car_array[i] as a car
                process.stdout.write(".");
                //await substrate_sim.sleep(20); //wait a little: get error "tx outdated" when one account sends too many tx/sec
                if (i % 100 == 0)
                    console.log(`\n${(i * 100) / car_array.length}%`)
            } catch (e) {
                console.log("")
                console.log(e.message)
            }
        }
        console.log("")
    }

    console.log("Wait block finalised")
    await substrate_sim.sleep(18000); //wait block finalised
    await substrate_sim.print_cars(api);

    console.log("Done")
}

main().catch(console.error).finally(() => process.exit(0));