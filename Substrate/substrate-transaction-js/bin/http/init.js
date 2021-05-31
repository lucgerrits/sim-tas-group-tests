#!/usr/bin/env node

import substrate_sim from "../../src/http/substrate_sim_http_lib.js";
import {
  methods,
} from "@substrate/txwrapper-substrate";
// import { deriveAddress } from '@substrate/txwrapper';

// if (process.argv.length <= 2) {
//     console.error("Required 2 argument: \n\tSend new factory: true/false.\n\tSend new car: true/false")
//     process.exit(1);
// }
const sidecarurl = "http://localhost:8888";
const publicKey = "0x2ca17d26ca376087dc30ed52deb74bf0f64aca96fe78b05ec3e720a72adb1235";

async function main() {
  console.log("Start init.js...")
  var api = await substrate_sim.initApi(sidecarurl);
  await substrate_sim.print_header(sidecarurl);

  console.log(api.params);



  // const unsigned = methods.balances.transferKeepAlive(
  //     { //data
  //       value: "90071992547409910",
  //       dest: "14E5nqKAp3oAJcmzgZhUD2RcptBeUBScxKHgJKU4HPNcKVf3", // Bob
  //     },
  //     {
  //       address: deriveAddress(publicKey),
  //       blockHash: "0x1fc7493f3c1e9ac758a183839906475f8363aafb1b1d3e910fe16fab4ae1b582",
  //       blockNumber: 4302222,
  //       eraPeriod: 64, // number of blocks from checkpoint that transaction is valid
  //       genesisHash: "0xe3777fa922cafbff200cadeaea1a76bd7898ad5b89f7848999058b50e715f636",
  //       metadataRpc, // must import from client RPC call state_getMetadata
  //       nonce: -1, 
  //       specVersion: 1019,
  //       tip: 0,
  //       transactionVersion: 1,
  //     },
  //     {
  //       metadataRpc,
  //       registry,
  //     }
  //   );
  console.log("Done")
}

main().catch(console.error).finally(() => process.exit(0));