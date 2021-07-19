#!/bin/bash

echo "Check if substrate-node-template up-to-date..."
cd ../../
git submodule update --init --recursive
cd - > /dev/null

echo "Hard reset of substrate-node-template"
cd substrate-node-template/ && git reset --hard
cd - > /dev/null

echo "Build release of node"
cd substrate-node-template/ 
cargo build --release
cd - > /dev/null

echo "Now you can run: ./substrate-node-template/target/release/node-template -h"