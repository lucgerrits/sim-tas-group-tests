#!/usr/bin/env node

// Import
import substrate_sim from "../src/substrate_sim_lib.js";
import { parallelLimit } from "async";

if (process.argv.length <= 2) {
    console.error("Required 1 argument: \n\limit, ex: 10000")
    process.exit(1);
}

async function send(api, car_array, limit, car_count, wait_time, nb_parallel) {
    var tmp = 0;
    var finished = 0;
    for (let i = 0; i < limit; i++) {
        (async function (i) {
            await substrate_sim.send.new_car_crash(api, car_array[i % car_count]);
            finished++;
        })(i)
        tmp += 1;
        if (tmp == nb_parallel) {
            console.log("Waiting", wait_time, "ms");
            await substrate_sim.sleep(parseInt(wait_time)); //wait a little
            tmp = 0;
        }
    }
    while (finished < limit) {
        console.log("Wait for thread close")
        await substrate_sim.sleep(parseInt(500)); //wait a little
    }
    console.log("Finished")
}


async function main() {
    console.log("Starting...")
    var api = await substrate_sim.initApi("ws://127.0.0.1:9944");

    await substrate_sim.print_header(api);
    console.log("Continue in 2s ...");
    await substrate_sim.sleep(2000); //wait a little

    const limit = parseInt(process.argv[2]);
    const wait_time = parseFloat(process.argv[3]) * 1000;
    const nb_parallel = parseInt(process.argv[4]);
    const car_array = substrate_sim.accounts.getAll();
    const car_count = car_array.length;


    await send(api, car_array, limit, car_count, wait_time, nb_parallel);
    console.log("Done")
}

main().catch(console.error).finally(() => process.exit());