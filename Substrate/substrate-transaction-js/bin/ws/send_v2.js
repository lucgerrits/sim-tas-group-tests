#!/usr/bin/env node

import * as child from 'child_process';
import * as path from 'path';

if (process.argv.length <= 2) {
    console.error("Required 3 argument: \n\tlimit, ex: 10000\n\twait_time, ex: 1 (sec)\n\tnb_processes, ex: 2")
    process.exit(1);
}
const limit = parseInt(process.argv[2]);
const wait_time = parseFloat(process.argv[3]) * 1000;
const nb_processes = parseInt(process.argv[4]);
var processes_arr = [];
var processes_exited = 0;
var processes_init_ok = 0;

console.log("Start processes")
// Create the worker.
for (let i = 0; i < nb_processes; i++) {
    processes_arr[i] = child.fork(path.join(".", "bin", "ws", "/sender.js"), [i]);


    //handle messages
    processes_arr[i].on('message', (message) => {
        if (message.cmd == "init_worker") { //first init all workers
            processes_arr[i].send({ cmd: "init" });
        }
        else if (message.cmd == "init_ok") { //wait all processes init ok
            processes_init_ok++;
            if (processes_init_ok == nb_processes) { //all processes ready
                //start send all processes 
                for (let j = 0; j < nb_processes; j++)
                    processes_arr[j].send({ cmd: "send", limit: parseInt(limit/nb_processes), wait_time: wait_time }); //start send
            }
        }
        else if (message.cmd == "send_ok") {
            processes_arr[i].send({ cmd: "exit" }); //exit when done
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
            process.exit(0);
        }

    });
}