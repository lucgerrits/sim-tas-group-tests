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
var car_array_nonces; //keep trak only factory nonces

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
        substrate_sim.accounts.makeAllAccounts(process_id, tot_processes) //init all accounts
        // await substrate_sim.print_header(api);
        process.send({ "cmd": "init_ok" });
    }
    else if (message.cmd == "send") {
        car_array = substrate_sim.accounts.getAllAccounts(process_id);
        car_array_nonces = substrate_sim.accounts.getAllAccountsNonces(process_id);

        //update nonces
        console.log(process_id_str + "update nonces...")
        for (let i = 0; i < car_array.length; i++) {
            car_array_nonces[i] = await api.rpc.system.accountNextIndex(car_array[i].address);
        }


        await substrate_sim.sleep(5000); //wait a little

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
            let car_index = i % car_array.length;
            substrate_sim.send.new_car_crash(api, car_array[car_index], car_array_nonces[car_index])
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
            car_array_nonces[car_index]++;
        })(i)
        await substrate_sim.sleep(parseInt(wait_time)); //wait a little
    }
    var a = true;
    while (finished < limit) {
        if (a) {
            console.log(process_id_str + "Wait new_car_crash() fct finished");
            a = false;
        }
        await substrate_sim.sleep(500); //wait a little
    }
    process.send({ "cmd": "send_stats", "success": success, "failed": failed, "finished": finished });
    // console.log(process_id_str + `Total success: ${success}`)
    // console.log(process_id_str + `Total failed: ${failed}`)
}