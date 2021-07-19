#!/bin/bash

# VALIDATORDATAPATH="./sawtooth-data/validator-data/"
# VALIDATORDATAPATH="/media/100GB/validator-data"

#use env:
export $(grep -v '^#' .env | xargs -d '\n')

do_build () {
    if [ ! -d ./sawtooth-sdk-rust ]; then
        echo -n "Can't find sawtooth-sdk-rust"
        echo "=> Cloning project"
        git clone --depth 1 --branch v0.5.0 https://github.com/hyperledger/sawtooth-sdk-rust.git sawtooth-sdk-rust
        echo "Done"
    fi

    echo -n "Adding cartp files in sawtooth-sdk-rust"
    # cp -rf ./cartp-data/bin/cartp-tp-rust ./sawtooth-sdk-rust/bin/
    # echo -n " ="
    cp -rf ./cartp-data/cartp_rust ./sawtooth-sdk-rust/examples/
    echo " => OK"

    USER_IS=$(who | awk '{print $1}')
    echo -n "Change permissions of ./sawtooth-sdk-rust to $USER_IS"
    sudo chown $USER_IS -R ./sawtooth-sdk-rust
    echo " => OK"

    echo "Delete validator data"
    if [ ! -d $VALIDATORDATAPATH ]; then
        sudo du -sh $VALIDATORDATAPATH
    fi
    sudo rm -rf $VALIDATORDATAPATH
    sudo rm -rf ./sawtooth-data/pbft-shared
    echo "Done"

    echo "make validator data dir"
    mkdir -p $VALIDATORDATAPATH
    mkdir -p $VALIDATORDATAPATH/v0
    mkdir -p $VALIDATORDATAPATH/v1
    mkdir -p $VALIDATORDATAPATH/v2
    mkdir -p $VALIDATORDATAPATH/v3
    mkdir -p $VALIDATORDATAPATH/v4
    mkdir -p ./sawtooth-data/pbft-shared
    echo "Done"


    sudo chown 104:104 -R ./stats-data/grafana-data
}



read -p "Are you sure to build (overwrite) cartp into sawtooth-sdk-python? [Yy]" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "===================Start======================"
    do_build
    echo "===================Done======================"
else
    echo "===================Stop======================"
fi