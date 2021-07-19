#!/usr/bin/env bash

cd polkadot_api_cpp/
rm CMakeCache.txt
# export CFLAGS=-DELPP_DISABLE_LOGS
# export CXXFLAGS=-DELPP_DISABLE_LOGS

export CFLAGS=-Wno-deprecated
export CXXFLAGS=-Wno-deprecated

cmake .
make VERBOSE=1 && sudo make install
