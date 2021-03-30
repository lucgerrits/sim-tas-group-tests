# substrate-transaction-cpp

C++ program to send transaction to Substrate, especialy for our SIM pallet.

## About Substrate storage

https://www.shawntabrizi.com/substrate/querying-substrate-storage-via-rpc/

## Notes

When installing polkadot_api_cpp:

export CFLAGS=-DELPP_DISABLE_LOGS
export CXXFLAGS=-DELPP_DISABLE_LOGS


Dependencies:

xxhash
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh
./vcpkg integrate install
./vcpkg install xxhash

