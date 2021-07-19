/*
    Substrate Client for SIM use case.

    by Luc Gerrits
*/

// use codec::{Decode, Encode};
// use sp_core::H256 as Hash;
// use std::convert::TryFrom;
// use substrate_api_client::sp_runtime::{
//     app_crypto::sr25519, app_crypto::DeriveJunction, app_crypto::Ss58Codec,
//     AccountId32 as AccountId,
// };
// use substrate_api_client::{AccountInfo, Api, Balance, BlockNumber, Metadata};

// use hex::decode;
// // use keyring::sr25519;
// use keyring::AccountKeyring;
// use std::str::FromStr;

// //Global contants
// const ALICE_SS58_ADDRESS: &str = "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY";
// const CHARLIE_SS58_ADDRESS: &str = "5FLSigC9HGRKVhB9FiEo4Y3koPsNmBmLJbpXg2mp1hXcS59Y";

// //Custom additional types
// #[derive(Encode, Decode, Default, Debug, Clone, PartialEq)]
// struct CrashType<BlockNumber> {
//     block_number: BlockNumber,
//     data: Vec<u8>,
// }

// fn main() {
//     println!("Hello, world!");
//     let url = format!("ws://{}", "127.0.0.1:9944");
//     let api = Api::<sr25519::Pair>::new(url).unwrap();

//     //Print all metadata information:
//     // let meta = Metadata::try_from(api.get_metadata().unwrap()).unwrap();
//     // meta.print_overview();
//     // print full substrate metadata json formatted
//     // println!(
//     //     "{}",
//     //     Metadata::pretty_format(&api.get_metadata().unwrap())
//     //         .unwrap_or_else(|| "pretty format failed".to_string())
//     // );

//     let result = api.get_finalized_head().unwrap().unwrap();
//     println!("[+] Chain head is {:?}", result);

//     let alice: AccountId = AccountId::from_str(ALICE_SS58_ADDRESS).unwrap();
//     let charlie: AccountId = AccountId::from_str(CHARLIE_SS58_ADDRESS).unwrap();
//     // YESSSSSSSS !!!! -> 90b5ab205c6974c9ea841be688864633dc9ca8a357843eeacf2314649965fe22 (= 0x90b5ab205c6974c9ea841be688864633dc9ca8a357843eeacf2314649965fe22)
//     println!("[+] charlie_account {:?}", charlie);

//     // get some plain storage value
//     let result: u128 = api
//         .get_storage_value("Balances", "TotalIssuance", None)
//         .unwrap()
//         .unwrap();
//     println!("[+] TotalIssuance is {}", result);

//     // get balance of charlie storage value
//     let result: Balance = api
//         .get_storage_map("Balances", "Account", &charlie, None)
//         .unwrap()
//         .or_else(|| Some(Balance::default()))
//         .unwrap();
//     println!("[+] Balance of Charlie is {}", result);
//     // get balance of alice storage value
//     let account = AccountKeyring::Alice.public();
//     let result: Balance = api
//         .get_storage_map("Balances", "Account", account, None)
//         .unwrap()
//         .or_else(|| Some(Balance::default()))
//         .unwrap();
//     println!("[+] Balance of Alice is {}", result);

//     // Get storage from state
//     let data: AccountId = api.get_storage_value("Sudo", "Key", None).unwrap().unwrap();
//     println!("[+] Sudo key account : {}", data);

//     let result: Hash = api
//         .get_storage_map("System", "BlockHash", 2u64, None)
//         .or_else(|_| Some(Hash::default()))
//         .unwrap();
//     println!("[+] block hash for blocknumber 2 is {:?}", result);

//     // let result: AccountInfo = api
//     //     .get_storage_map("System", "Account", charlie, None)
//     //     .unwrap()
//     //     .or_else(|| Some(AccountInfo::default()))
//     //     .unwrap();
//     // println!("[+] block hash for blocknumber 2 is {:?}", result);

//     println!("Done");
// }

use codec::{Decode, Encode};
// use node_primitives::{AccountId, BlockNumber};
// use sp_core::{
//     storage::{StorageChangeSet, StorageData, StorageKey},
//     Bytes,
// };
use sp_keyring::{AccountKeyring, Sr25519Keyring};
// use sp_runtime::MultiAddress;
// use sp_core::crypto::{Pair, DEV_PHRASE};
use core::marker::PhantomData;
// use sp_core::{crypto::key_types::ACCOUNT, crypto::DEV_PHRASE, Pair, Public};
// use std::convert::From;
// use std::convert::AsMut;
// use std::convert::AsRef;
// use std::error::Error;
// use std::str::FromStr;
use substrate_subxt::{
    // balances::{TransferCallExt, TransferEventExt},
    // system::AccountId32,
    sp_runtime::AccountId32,
    // sp_runtime::MultiAddress,
    // Signer,
    // keystore,
    sudo::{Sudo, SudoCall},
    // system::AccountInfo,
    system::AccountStore,
    Client,
    // crypto::AccountId32
    ClientBuilder,
    // DefaultNodeRuntime,
    NodeTemplateRuntime as MyRuntime,
    PairSigner,
    // Runtime,
    // Pair,
    // UncheckedExtrinsic,
};
use substrate_subxt_proc_macro::{Call, Store};
pub mod runtime;

async fn get_balance(
    client: &Client<MyRuntime>,
    who: &AccountId32,
    verbose: bool,
) -> u32 {
    // get balance of alice and charlie:
    let account_info = client
        .fetch_or_default(&AccountStore { account_id: who }, None)
        .await
        .unwrap();
    if verbose {
        // println!("[+] Alice AccountInfo: {:?}", account_info);
        println!("[+] Balance of {:?}: {:?}", who, account_info.data.free);
    }
    return 1;
}



// async fn new_factory(
//     client: &Client<MyRuntime>,
//     signer: &Sr25519Keyring,
//     who: &AccountId32,
//     verbose: bool,
// ) {
//     let signer = PairSigner::new(signer.pair());
//     let call = StoreFactoryCall { factory_id: &who };
//     let encoded = client.encode(call).unwrap();
//     let sudo_call = SudoCall {
//         call: &encoded,
//         _runtime: PhantomData,
//     };
//     let extrinsic = client.create_signed(sudo_call, &signer).await;
//     let result = client.submit_and_watch_extrinsic(extrinsic).await;
// }

// //Global contants
const ALICE_SS58_ADDRESS: &str = "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY";
const CHARLIE_SS58_ADDRESS: &str = "5FLSigC9HGRKVhB9FiEo4Y3koPsNmBmLJbpXg2mp1hXcS59Y";

#[async_std::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = format!("ws://{}", "127.0.0.1:9944");
    env_logger::init();

    //////////////////////////////////////////////////////
    //  Load some accounts
    //
    let alice = AccountKeyring::Alice;
    // let alice_signer = PairSigner::new(alice.pair());
    let charlie = AccountKeyring::Charlie;

    // let alice: AccountId = AccountId::decode(CHARLIE_SS58_ADDRESS_BYTES).unwrap_or_default();
    // let alice: AccountId32 = AccountId32::from_str(ALICE_SS58_ADDRESS).unwrap();
    // let charlie: AccountId32 = AccountId32::from_str(CHARLIE_SS58_ADDRESS).unwrap();
    // let charlie_address =
    //     MultiAddress::from(AccountId::decode(&mut charlie.encode().as_ref()).unwrap_or_default());
    // let charlie_address = MultiAddress::from(charlie.clone());
    // let alice_pair = Pair::from_string(DEV_PHRASE.as_ref(), None);
    // let signer = PairSigner::new(signer);
    // println!("alice_pair: {:?}", alice_pair);

    //////////////////////////////////////////////////////
    //  Load client
    //
    let client = ClientBuilder::<MyRuntime>::new()
        .set_url(url)
        .build()
        .await?;

    //////////////////////////////////////////////////////
    //  Print some data
    //
    // let genesis = client.genesis();
    // println!("[+] Genesis is {:?}", genesis);
    let module_hash = sp_core::twox_128(b"SimModule");
    println!("module hash: {:?}", module_hash);
    println!("module hash: {:?}", hex::encode(module_hash));

    // new_factory(&client, &alice.public().into(), true).await;

    //////////////////////////////////////////////////////
    //  Example to send amount from aloce to charlie
    //
    // let amount_to_send: u128 = 10_000_000_000;
    // get_balance(&client, &alice.public().into(), true).await;
    // get_balance(&client, &charlie.public().into(), true).await;

    // let result = client
    //     .transfer_and_watch(
    //         &PairSigner::new(alice.pair()),
    //         &charlie.to_account_id().into(),
    //         amount_to_send,
    //     )
    //     .await?;
    // if let Some(event) = result.transfer()? {
    //     println!("Balance transfer success: value: {:?}", event.amount);
    // } else {
    //     println!("Failed to find Balances::Transfer Event");
    // }

    // // get balance of alice and charlie:
    // get_balance(&client, &alice.public().into(), true).await;
    // get_balance(&client, &charlie.public().into(), true).await;

    println!("\nDone");

    Ok(())
}
