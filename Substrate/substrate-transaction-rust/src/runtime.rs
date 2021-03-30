use codec::Encode;
use core::marker::PhantomData;
use sp_core::{sr25519::Pair, Pair as TraitPair};
use std::error::Error;
use substrate_subxt::{
	Store,
	sudo::{Sudo, SudoCall},
	system::{SetCodeCall, System},
	Call, Client, NodeTemplateRuntime as MyRuntime, Encoded, PairSigner,
};

#[substrate_subxt::module]
pub trait SimModule: System + Sudo {}

impl SimModule for MyRuntime {}

// #[derive(Call)]
// pub struct FunStuffCall<T: SimModule> {
// 	/// Runtime marker.
// 	pub _runtime: PhantomData<T>,
// 	/// The argument passed to the call..
// 	pub something: Vec<u8>,
// }
// #[derive(Clone, Debug, PartialEq, Call, Encode)]
// pub struct StoreFactoryCall<AccountId> {
//     pub factory_id: AccountId,
// }

#[derive(Clone, Debug, Eq, PartialEq, Store, Encode)]
pub struct FactoriesStore<'a, T: SimModule> {
	#[store(returns = T::BlockNumber)]
	/// according account to get voucher
	pub account_id: &'a T::AccountId,
}