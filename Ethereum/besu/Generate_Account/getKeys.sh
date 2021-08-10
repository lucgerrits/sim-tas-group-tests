#!/bin/bash

# To get the Public, Private and Id of the Key

yourfilenames=`ls keys`
echo "Id"
for eachfile in $yourfilenames
do
        echo $eachfile
done
echo "Public Key"
for eachfile in $yourfilenames
do
        echo $(cat keys/$eachfile/key.pub)
done
echo "Private Key"
for eachfile in $yourfilenames
do
        echo $(cat keys/$eachfile/key)
done
