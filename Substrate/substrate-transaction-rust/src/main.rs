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

// use codec::{Decode, Encode};
// use node_primitives::{AccountId, BlockNumber};
// use sp_core::{
//     storage::{StorageChangeSet, StorageData, StorageKey},
//     Bytes,
// };
use sp_keyring::AccountKeyring;
// use sp_runtime::MultiAddress;
// use sp_core::crypto::{Pair, DEV_PHRASE};
use sp_core::{Pair, crypto::DEV_PHRASE, crypto::key_types::ACCOUNT};
use std::convert::From;
// use std::convert::AsMut;
// use std::convert::AsRef;
use std::str::FromStr;
use substrate_subxt::{
    balances::{TransferCallExt, TransferEventExt},
    // system::AccountId32,
    sp_runtime::AccountId32,
    sp_runtime::MultiAddress,
    // system::AccountInfo,
    system::AccountStore,
    // Client,
    // crypto::AccountId32
    ClientBuilder,
    DefaultNodeRuntime,
    PairSigner,
    // Pair,
    Runtime,
    // Signer,
    // keystore,
};
use std::error::Error;

// fn getBalance(client: Client<_>, account: AccountId32) -> u32 {

//     return 1;
// }

// //Global contants
const ALICE_SS58_ADDRESS: &str = "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY";
const CHARLIE_SS58_ADDRESS: &str = "5FLSigC9HGRKVhB9FiEo4Y3koPsNmBmLJbpXg2mp1hXcS59Y";

#[async_std::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // let a = AccountId32::from_str(ALICE_SS58_ADDRESS).unwrap().encode();
    // let ac = AccountId32::encode(&mut a.unwrap());
    // let alice2:AccountId = AccountId::decode(&mut a.as_ref()).unwrap_or_default();
    //    T::AccountId::decode(&mut &ac[..]).map_err(|_| <Error<T>>::AccountIdParseError)?;

    let url = format!("ws://{}", "127.0.0.1:9944");
    env_logger::init();

    let signer = PairSigner::new(AccountKeyring::Alice.pair());
    // let dest = AccountKeyring::Bob.to_account_id().into();

    // let alice: AccountId = AccountId::decode(CHARLIE_SS58_ADDRESS_BYTES).unwrap_or_default();

    let alice: AccountId32 = AccountId32::from_str(ALICE_SS58_ADDRESS).unwrap();
    let charlie: AccountId32 = AccountId32::from_str(CHARLIE_SS58_ADDRESS).unwrap();
    // let charlie_address =
    //     MultiAddress::from(AccountId::decode(&mut charlie.encode().as_ref()).unwrap_or_default());
    let charlie_address = MultiAddress::from(charlie.clone());
    // let alice_pair = Pair::
    // let alice_pair = Pair::from_phrase(DEV_PHRASE.as_ref(), None)?;

    let alice_pair = Pair::from_string(DEV_PHRASE.as_ref(), None);
	// let signer = PairSigner::new(signer);
    println!("alice_pair: {:?}", alice_pair);
    // let alice_signer = PairSigner::new(alice_pair);

    let client = ClientBuilder::<DefaultNodeRuntime>::new()
        .set_url(url)
        .build()
        .await?;

    // let genesis = client.genesis();
    // println!("[+] Genesis is {:?}", genesis);

    // let cars_data = StorageKey::
    // let result = client.fetch_keys(2);
    // println!("[+] Result is {:?}", result);

    //
    //Example to send amount from aloce to charlie
    //
    let amount_to_send: u128 = 10_000_000_000;
    // get balance of alice and charlie:
    let alice_account_info = client
        .fetch_or_default(&AccountStore { account_id: &alice }, None)
        .await
        .unwrap();
    let charlie_account_info = client
        .fetch_or_default(
            &AccountStore {
                account_id: &charlie,
            },
            None,
        )
        .await
        .unwrap();
    // println!("[+] Alice AccountInfo: {:?}", alice_account_info);
    println!("[+] Balance of Alice: {:?}", alice_account_info.data.free);
    println!(
        "[+] Balance of Charlie: {:?}",
        charlie_account_info.data.free
    );

    let result = client
        .transfer_and_watch(&signer, &charlie_address, amount_to_send)
        .await?;
    if let Some(event) = result.transfer()? {
        println!("Balance transfer success: value: {:?}", event.amount);
    } else {
        println!("Failed to find Balances::Transfer Event");
    }

    // get balance of alice and charlie:
    let alice_account_info = client
        .fetch_or_default(&AccountStore { account_id: &alice }, None)
        .await
        .unwrap();
    let charlie_account_info = client
        .fetch_or_default(
            &AccountStore {
                account_id: &charlie,
            },
            None,
        )
        .await
        .unwrap();
    // println!("[+] Alice AccountInfo: {:?}", alice_account_info);
    println!("[+] Balance of Alice: {:?}", alice_account_info.data.free);
    println!(
        "[+] Balance of Charlie: {:?}",
        charlie_account_info.data.free
    );

    println!("\nDone");

    Ok(())
}
