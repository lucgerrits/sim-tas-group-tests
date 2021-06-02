#!/usr/bin/env node

// Import
import substrate_sim from "../src/ws/substrate_sim_lib.js";
import { writeFileSync, unlinkSync, existsSync } from 'fs'
const filename = "accounts.json"

if (process.argv.length <= 2) {
    console.error("Required 1 argument: number of accounts to generate. Ex: 100")
    process.exit(1);
}

async function main() {
    console.log("Start genAccounts.js...")
    console.log("Delete old file...")
    if (existsSync(filename)) {
        unlinkSync(filename);
    }

    const account_pair_size = parseInt(process.argv[2]);
    console.log(`Creating ${account_pair_size} accounts...`)
    var ACCOUNT_PAIRS = [];
    for (let i = 0; i < account_pair_size; i++) {
        console.clear();
        console.log(`Loading account list ${i * 100 / account_pair_size}%`)
        ACCOUNT_PAIRS.push(substrate_sim.accounts.genMnemonic())
    }
    writeFileSync(filename, JSON.stringify(ACCOUNT_PAIRS, null, 1), { encoding: "utf8", flag: "a+" })
    console.log("Done")
}

main().catch(console.error).finally(() => process.exit(0));