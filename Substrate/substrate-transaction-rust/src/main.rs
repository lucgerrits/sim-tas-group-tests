/*
    Substrate Client for SIM use case.

    by Luc Gerrits
*/

use codec::{Decode, Encode};
use std::convert::TryFrom;
use substrate_api_client::sp_runtime::{AccountId32, app_crypto, };
use substrate_api_client::{AccountInfo, Api, BlockNumber, Metadata};

use keyring::AccountKeyring;
use keyring::sr25519;
use hex::decode;
use std::str::FromStr;

//Custom additional types
#[derive(Encode, Decode, Default, Debug, Clone, PartialEq)]
struct CrashType<BlockNumber> {
    block_number: BlockNumber,
    data: Vec<u8>,
}

fn main() {
    println!("Hello, world!");
    let url = format!("ws://{}", "127.0.0.1:9944");
    let api = Api::<app_crypto::sr25519::Pair>::new(url).unwrap();

    //Print all metadata information:
    // let meta = Metadata::try_from(api.get_metadata().unwrap()).unwrap();
    // meta.print_overview();

    let head = api.get_finalized_head().unwrap().unwrap();
    println!("[+] Chain head is {:?}", head);

    // : Vec<CrashType<BlockNumber>>
    // let result: (AccountId32, BlockNumber) = api
    //     .get_storage_map(
    //         "Sim",
    //         "Cars",
    //         "5FLSigC9HGRKVhB9FiEo4Y3koPsNmBmLJbpXg2mp1hXcS59Y",
    //         None,
    //     )
    //     .unwrap()
    //     .unwrap();

    // println!("Cars {:?}", result);

    // get some plain storage value
    let result: u128 = api
        .get_storage_value("Balances", "TotalIssuance", None)
        .unwrap()
        .unwrap();
    println!("[+] TotalIssuance is {}", result);


    // let charlie_decoded_ss58: app_crypto::Ss58Codec:: = app_crypto::Ss58Codec::from_string("5FLSigC9HGRKVhB9FiEo4Y3koPsNmBmLJbpXg2mp1hXcS59Y").unwrap();

    let charlie: AccountId32 = AccountId32::from_str("5FLSigC9HGRKVhB9FiEo4Y3koPsNmBmLJbpXg2mp1hXcS59Y").unwrap();

    println!("charlie_account {:?}", charlie.public());
    // let charlie_account = app_crypto::sr25519::Public(charlie);
    //or
    let my_pub_key = app_crypto::DeriveJunction::soft("5FLSigC9HGRKVhB9FiEo4Y3koPsNmBmLJbpXg2mp1hXcS59Y").soften();
    let charlie_account = app_crypto::sr25519::Public(my_pub_key.unwrap_inner());
    println!("charlie_account {}", charlie_account);

    // get StorageMap
    let alice_account = AccountKeyring::Alice.public();
    let result: AccountInfo = api
        .get_storage_map("System", "Account", charlie_account, None)
        .unwrap()
        .or_else(|| Some(AccountInfo::default()))
        .unwrap();
    println!("[+] AccountInfo for Alice is {:?}", result);

    println!("Done");
}
