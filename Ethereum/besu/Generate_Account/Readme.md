1) Prepare IBFT Config Dummy File
ibftConfigFile.json
2) Download the binary

3) Install the JDK
sudo apt update
sudo apt install default-jdk

4) Get the binary in the current folder
 wget https://hyperledger.jfrog.io/artifactory/besu-binaries/besu/21.7.2/besu-21.7.2.zip
 unzip besu-21.7.2.zip

4) Generate Config File 
./besu operator generate-blockchain-config --config-file=ibftConfigFile.json --to=networkFiles --private-key-file-name=key

5) Get the Address, Public Key, Private Key details of the generate nodes in the txt

./getKeys.sh > output.txt

6) Add the Address, Public, Private to the createextradata.sh

7) To get the extradata for all Node configurations in an array

./createextradata.sh 

8) Check the final file extradatavalue.json