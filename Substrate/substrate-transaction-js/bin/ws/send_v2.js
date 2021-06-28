#!/usr/bin/env node

import substrate_sim from "../../src/ws/substrate_sim_lib.js";
import * as child from 'child_process';
import * as path from 'path';
import * as async from "async";

// if (process.argv.length <= 2) {
//     console.error("Required 3 argument: \n\tlimit, ex: 10000\n\twait_time, ex: 1 (sec)\n\tnb_processes, ex: 2")
//     process.exit(1);
// }
const limit = parseInt(process.argv[2]);
const nb_processes = 14; //parseInt(process.argv[4]);
const wait_time = (nb_processes / parseFloat(process.argv[3])) * 1000;// parseFloat(process.argv[3]) * 1000;
var processes_arr = [];
var processes_exited = 0;
var processes_finished = 0;
var processes_init_ok = 0;
var processes_prepare_ok = 0;

var tot_success = 0;
var tot_failed = 0;
var tot_finished = 0;
var tot_prepared_finished = 0;

var firstBlock;
var lastBlock;

function do_benchmark(callback) {
    console.log("Benchmark settings:")
    // console.log("\t", nb_processes * (1 / parseFloat(process.argv[3])), "Tx/sec")
    console.log("\t", parseFloat(process.argv[3]), "Tx/sec")
    console.log("\t wait_time=", wait_time, "ms")
    console.log("Start processes")
    // Create the worker.
    for (let i = 0; i < nb_processes; i++) {
        processes_arr[i] = child.fork(path.join(".", "bin", "ws", "/sender.js"), [i, nb_processes]);


        //handle messages
        processes_arr[i].on('message', async (message) => {
            if (message.cmd == "init_worker") { //first init all workers
                processes_arr[i].send({ cmd: "init" });
            }
            else if (message.cmd == "init_ok") { //wait all processes init ok
                processes_init_ok++;
                if (processes_init_ok == nb_processes) { //all processes ready
                    //start send all processes 
                    console.log("All processes synced")
                    for (let j = 0; j < nb_processes; j++)
                        processes_arr[j].send({ cmd: "prepare", limit: parseInt(limit / nb_processes) }); //start send
                }
            }
            else if (message.cmd == "prepare_ok") {
                processes_prepare_ok++;
                if (processes_prepare_ok == nb_processes) { //all processes ready
                    //start send all processes 
                    console.log("All processes prepared")
                    console.log(`Total prepared finished: ${tot_prepared_finished}`)
                    await substrate_sim.sleep(5000); //wait a little

                    processes_arr[0].send({ cmd: "get_head", type: "first" }); //get first block
                }
            }
            else if (message.cmd == "get_head_ok" && message.type == "first") { //if we got first block (start sending)
                firstBlock = {
                    hash: message.hash,
                    number: message.number
                }
                for (let j = 0; j < nb_processes; j++)
                    processes_arr[j].send({ cmd: "send", wait_time: wait_time }); //start send
            }
            else if (message.cmd == "get_head_ok" && message.type == "last") { //if we got last block (exit process)
                lastBlock = {
                    hash: message.hash,
                    number: message.number
                }
                for (let j = 0; j < nb_processes; j++)
                    processes_arr[j].send({ cmd: "exit" }); //exit when done
            }
            else if (message.cmd == "prepare_stats") {
                tot_prepared_finished += message.finished;
            }
            else if (message.cmd == "send_stats") {
                // console.log(message)
                tot_success += message.success;
                tot_failed += message.failed;
                tot_finished += message.finished;
            }
            else if (message.cmd == "send_ok") {
                processes_finished++;
                if (processes_finished == nb_processes) { //all processes finished
                    //start send all processes 
                    console.log("All processes finished")
                    await substrate_sim.sleep(6000); //wait a little

                    processes_arr[0].send({ cmd: "get_head", type: "last" }); //get last block
                }
            }
        });


        //handle exit
        processes_arr[i].on('exit', () => {
            //proccess exit
            processes_exited++;
            if (processes_exited == nb_processes) {
                //if all processes exited -> stop main process
                console.log("All processes exited.")
                console.log("Done main worker")

                console.log(`Total success: ${tot_success}`)
                console.log(`Total failed: ${tot_failed}`)
                console.log(`Total finished: ${tot_finished}`)

                console.log("firstBlock", firstBlock)
                console.log("lastBlock", lastBlock)
                callback()
            }
        });
    }
}

async function do_stats(callback) {
    console.log("Retrieving stats");

    var api = await substrate_sim.initApi(url);

    await substrate_sim.print_header(api);
    console.log("Continue in 2s ...");
    await substrate_sim.sleep(1000); //wait a little

    var last_block = await api.rpc.chain.getHeader();
    var last_block_number = last_block.number.toNumber();

    for (var block_number = 0; block_number < last_block_number; block_number++) {
        console.log(block_number);
        let block_hash = await api.rpc.chain.getBlockHash(block_number);
        let block_data = await api.rpc.chain.getBlock(block_hash);
        if (block_data.block.extrinsics.length > 3) {
            console.log(block_data.block.toJSON());
            break;
        }
    }

    console.log("Done retrieving stats")
    callback()
}

async.series([
    do_benchmark,
    // do_stats
], () => {
    console.log("End main program")
    process.exit(0);
})