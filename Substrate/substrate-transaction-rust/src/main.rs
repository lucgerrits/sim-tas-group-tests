/*
    Substrate Client for SIM use case.

    by Luc Gerrits
*/

use codec::{Decode, Encode};
use std::convert::TryFrom;
use substrate_api_client::sp_runtime::{
    app_crypto::sr25519, app_crypto::DeriveJunction, app_crypto::Ss58Codec, AccountId32,
};
use substrate_api_client::{AccountInfo, Api, BlockNumber, Metadata};

use hex::decode;
// use keyring::sr25519;
use keyring::AccountKeyring;
use std::str::FromStr;

//Global contants
const CHARLIE_SS58_ADDRESS: &str = "5FLSigC9HGRKVhB9FiEo4Y3koPsNmBmLJbpXg2mp1hXcS59Y";

//Custom additional types
#[derive(Encode, Decode, Default, Debug, Clone, PartialEq)]
struct CrashType<BlockNumber> {
    block_number: BlockNumber,
    data: Vec<u8>,
}

fn main() {
    println!("Hello, world!");
    let url = format!("ws://{}", "127.0.0.1:9944");
    let api = Api::<sr25519::Pair>::new(url).unwrap();

    //Print all metadata information:
    let meta = Metadata::try_from(api.get_metadata().unwrap()).unwrap();
    // meta.print_overview();
    // print full substrate metadata json formatted
    println!(
        "{}",
        Metadata::pretty_format(&api.get_metadata().unwrap())
            .unwrap_or_else(|| "pretty format failed".to_string())
    );

    let head = api.get_finalized_head().unwrap().unwrap();
    println!("[+] Chain head is {:?}", head);

    // get some plain storage value
    let result: u128 = api
        .get_storage_value("Balances", "TotalIssuance", None)
        .unwrap()
        .unwrap();
    println!("[+] TotalIssuance is {}", result);

    let charlie: AccountId32 = AccountId32::from_str(CHARLIE_SS58_ADDRESS).unwrap();
    // YESSSSSSSS !!!! -> 90b5ab205c6974c9ea841be688864633dc9ca8a357843eeacf2314649965fe22 (= 0x90b5ab205c6974c9ea841be688864633dc9ca8a357843eeacf2314649965fe22)
    println!("charlie_account {:?}", charlie);

    // Get storage from state
    let data: AccountId32 = api
        .get_storage_value("Sudo", "Key", None)
        .unwrap()
        .unwrap();
    println!("[+] Sudo key account : {}\n", data);

    // // get the Kitty
    // let kitty: Kitty = api.get_storage_map("Kitty", "Kitties", index).unwrap();
    // println!("[+] Cute decoded Kitty: {:?}\n", kitty);

    // let result: AccountInfo = api
    //     .get_storage_map("System", "Account", charlie, None)
    //     .unwrap()
    //     .or_else(|| Some(AccountInfo::default()))
    //     .unwrap();
    // println!("[+] AccountInfo for Alice is {:?}", result);

    println!("Done");
}
