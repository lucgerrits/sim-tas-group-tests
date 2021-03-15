#![cfg_attr(not(feature = "std"), no_std)]

use frame_support::{
	decl_error,
	decl_event,
	decl_module,
	decl_storage,
	dispatch,
	ensure,
	traits::Get,
	StorageMap,
	// debug,
	// traits::{EnsureOrigin}
};
use frame_system::ensure_root;
use frame_system::ensure_signed;

use sp_std::vec::Vec;

//these types need to be declared in the telemetry dashboard,
//see file: /Substrate/substrate-node-template/additional_types.json
// type FactoryId<T> = <T as frame_system::Trait>::AccountId;
// type CarId<T> = <T as frame_system::Trait>::AccountId;

/// Configure the pallet by specifying the parameters and types on which it depends.
pub trait Trait: frame_system::Trait {
	/// Because this pallet emits events, it depends on the runtime's definition of an event.
	type Event: From<Event<Self>> + Into<<Self as frame_system::Trait>::Event>;
	// type ForceOrigin: EnsureOrigin<Self::Origin>;
}

// The pallet's runtime storage items.
decl_storage! {
	trait Store for Module<T: Trait> as SimModule {
		/// List of factory IDs added by the admin (sudo)
		Factories: map hasher(blake2_128_concat) T::AccountId => T::BlockNumber; //factory => block nb

		/// List of car ID added by the factories
		/// (
		///
		///
		///
		/// )
		Cars: map hasher(blake2_128_concat) T::AccountId => (T::AccountId, T::BlockNumber); //car => factory , block nb

		/// List of car crashes added by a car
		/// Crashes are declared in a map. Each car_id contains a vector of data hashes:
		/// (
		///   car_id => Vec<data_hash>,
		///   car_id => Vec<data_hash>,
		///   ...
		/// )
		Crashes: map hasher(blake2_128_concat) T::AccountId => Vec<Vec<u8>>;
	}
}

// Pallets use events to inform users when important changes are made.
decl_event!(
	pub enum Event<T>
	where
		AccountId = <T as frame_system::Trait>::AccountId,
	{
		//, Factory = Vec<u8>, Car = Vec<u8>, Data = Vec<u8>
		/// Event when a factory has been added to storage.
		FactoryStored(AccountId),
		/// Event when a car has been added to storage by a factory.
		CarStored(AccountId, AccountId),
		/// Event when data (hash) is stored by a car and an account.
		DataStored(AccountId, AccountId, Vec<u8>),
	}
);

// Errors inform users that something went wrong.
decl_error! {
	pub enum Error for Module<T: Trait> {
		/// Error names should be descriptive.
		NoneValue,
		/// Errors should have helpful documentation associated with them.
		StorageOverflow,
		/// Factory is not in storage: permission denied.
		UnknownFactory,
		/// Car is not in storage: permission denied
		UnknownCar,
		/// Car is already in storage
		CarAlreadyStored,
		/// Factory is already in storage
		FactoryAlreadyStored,
	}
}

// Dispatchable functions allows users to interact with the pallet and invoke state changes.
// These functions materialize as "extrinsics", which are often compared to transactions.
// Dispatchable functions must be annotated with a weight and must return a DispatchResult.
decl_module! {
	pub struct Module<T: Trait> for enum Call where origin: T::Origin {
		// Errors must be initialized if they are used by the pallet.
		type Error = Error<T>;

		// Events must be initialized if they are used by the pallet.
		fn deposit_event() = default;

		/// Dispatchable that takes a singles value as a parameter (factory ID), writes the value to
		/// storage (factories) and emits an event. This function must be dispatched by a signed extrinsic.
		// #[weight = 10_000 + T::DbWeight::get().writes(1)]
		#[weight = 10_000]
		pub fn store_factory(origin, factory_id: <T as frame_system::Trait>::AccountId) -> dispatch::DispatchResult {
			// let origin_copy = origin.clone();
			ensure_root(origin)?;
			// let who = ensure_signed(origin_copy)?;

			// Verify that the specified factory_id has not already been stored.
			ensure!(!Factories::<T>::contains_key(&factory_id), Error::<T>::FactoryAlreadyStored);


			// Get the block number from the FRAME System module.
			let current_block = <frame_system::Module<T>>::block_number();

			// Store the factory_id with the sender and block number.
			Factories::<T>::insert(&factory_id, current_block);

			// debug::debug!(target: "mydebug", "who={:?}", who);
			// debug::debug!(target: "mydebug", "factory_id={:?}", factory_id);
			// debug::debug!(target: "mydebug", "current_block={:?}", current_block);

			// Emit an event.
			Self::deposit_event(RawEvent::FactoryStored(factory_id));
			// Return a successful DispatchResult
			Ok(())
		}

		/// Dispatchable that takes a singles value as a parameter (factory ID), writes the value to
		/// storage (factories) and emits an event. This function must be dispatched by a signed extrinsic.
		#[weight = 10_000 + T::DbWeight::get().writes(1)]
		pub fn store_car(origin, car_id: <T as frame_system::Trait>::AccountId) -> dispatch::DispatchResult {
			let who = ensure_signed(origin)?;

			// Verify that the specified factory_id exists.
			ensure!(Factories::<T>::contains_key(&who), Error::<T>::UnknownFactory);


			// Verify that the specified car_id has not already been stored.
			ensure!(!Cars::<T>::contains_key(&who), Error::<T>::CarAlreadyStored);


			// Get the block number from the FRAME System module.
			let current_block = <frame_system::Module<T>>::block_number();

			// Store the factory_id with the sender and block number.
			Cars::<T>::insert(&car_id, (&car_id, current_block));

			// debug::debug!(target: "mydebug", "who={:#?}", who);
			// debug::debug!(target: "mydebug", "factory_id={:#?}", factory_id);
			// debug::debug!(target: "mydebug", "car_id={:#?}", car_id);
			// debug::debug!(target: "mydebug", "current_block={:#?}", current_block);

			// Emit an event.
			Self::deposit_event(RawEvent::CarStored(car_id, who));
			// Return a successful DispatchResult
			Ok(())
		}
	}
}
