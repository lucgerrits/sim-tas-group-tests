// Import
import substrate_sim from "../../src/ws/substrate_sim_lib.js";

//TODO:
// separate car_array into slices to prevent sending same transactions


const tot_processes = parseInt(process.argv[2]);
const process_id = parseInt(process.argv[2]);
const process_id_str = '#' + process.argv[2] + ": ";
var api;

if (process.send === undefined)
    console.log(process_id_str + "process.send === undefined")
process.send({ "cmd": "init_worker" });

process.on('message', async (message) => {
    if (message.cmd == "exit") {
        process.exit(0);
    }
    else if (message.cmd == "init") {
        console.log(process_id_str + "init api...")
        api = await substrate_sim.initApi("ws://127.0.0.1:9944");
        await substrate_sim.print_header(api);
        process.send({ "cmd": "init_ok" });
    }
    else if (message.cmd == "send") {
        const car_array = substrate_sim.accounts.getAll();
        const car_count = car_array.length;

        console.log(process_id_str + "Sending now...")
        await send(car_array, message.limit, car_count, message.wait_time);
        console.log(process_id_str + "Done")
        process.send({ "cmd": "send_ok" });
    }
    else {
        console.log(process_id_str + "Unknown message", message);
    }
});

async function send(car_array, limit, car_count, wait_time) {
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
                    console.log(process_id_str, e)
                    finished++;
                    failed++;
                    return;
                });
        })(i)
        await substrate_sim.sleep(parseInt(wait_time)); //wait a little
    }
    while (finished < limit) {
        console.log(process_id_str + "Wait for thread close")
        await substrate_sim.sleep(parseInt(500)); //wait a little
    }
    console.log(process_id_str + `Total success: ${success}`)
    console.log(process_id_str + `Total failed: ${failed}`)
}