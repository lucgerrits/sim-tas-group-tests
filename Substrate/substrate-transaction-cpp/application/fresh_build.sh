#!/usr/bin/env bash

rm -rf substrate-transaction-cpp
rm -rf CMakeCache.txt
# export CFLAGS=-DELPP_DISABLE_LOGS
# export CXXFLAGS=-DELPP_DISABLE_LOGS
cmake .
make $1 #VERBOSE=1
# ./substrate-transaction-cpp