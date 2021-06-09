// Import
import substrate_sim from "../../src/ws/substrate_sim_lib.js";

//TODO:
// separate car_array into slices to prevent sending same transactions

// const url = "ws://127.0.0.1:9944";
const url = "ws://substrate-ws.unice.cust.tasfrance.com";

const process_id = parseInt(process.argv[2]);
const tot_processes = parseInt(process.argv[3]);
const process_id_str = '#' + process_id + ": ";
var api;
var car_array;
var car_count;

if (process.send === undefined)
    console.log(process_id_str + "process.send === undefined")
process.send({ "cmd": "init_worker" });

process.on('message', async (message) => {
    if (message.cmd == "exit") {
        process.exit(0);
    }
    else if (message.cmd == "init") {
        // console.log(process_id_str + "init api...")
        api = await substrate_sim.initApi(url, process_id, tot_processes);
        // await substrate_sim.print_header(api);
        process.send({ "cmd": "init_ok" });
    }
    else if (message.cmd == "send") {
        car_array = substrate_sim.accounts.getAllAccounts(process_id);
        car_count = car_array.length;
        // console.log(car_count)
        // car_count = parseInt(car_array.length / tot_processes);
        // car_array = car_array.slice(process_id * car_count, (process_id + 1) * car_count);
        // console.log("car_count", car_count)
        // console.log("car_array", car_array.length)
        await substrate_sim.sleep(parseInt(5000)); //wait a little

        console.log(process_id_str + "Sending now...")
        await send(message.limit, message.wait_time);
        console.log(process_id_str + "Done")
        process.send({ "cmd": "send_ok" });
    }
    else {
        console.log(process_id_str + "Unknown message", message);
    }
});

async function send(limit, wait_time) {
    var finished = 0;
    var success = 0;
    var failed = 0;
    for (let i = 0; i < limit; i++) {
        (async function (i) {
            if (i % 100 == 0)
                console.log(process_id_str + `N=${i}`)
            substrate_sim.send.new_car_crash(api, car_array[i % car_count])
                .then(() => {
                    finished++;
                    success++;
                    return;
                })
                .catch((e) => {
                    // process.stdout.write(".");
                    // console.log(process_id_str, e.message)
                    finished++;
                    failed++;
                    return;
                });
        })(i)
        await substrate_sim.sleep(parseInt(wait_time)); //wait a little
    }
    var a = true;
    while (finished < limit) {
        if (a) {
            console.log(process_id_str + "Wait new_car_crash() fct finished");
            a = false;
        }
        await substrate_sim.sleep(parseInt(500)); //wait a little
    }
    console.log(process_id_str + `Total success: ${success}`)
    console.log(process_id_str + `Total failed: ${failed}`)
}