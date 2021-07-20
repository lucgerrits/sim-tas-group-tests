**State**: Working but need to fix batch sending issue.
# substrate-transaction-js

Javascript client for Substrate.

## Dependencies

- polkadot-api
- TODO

## Init blockchain

```bash
#first create car and factories identities
./bin/genAccounts.js 5000 10 #5000 cars and 10 factories

#init the identities in the blockchain
./bin/ws/init_v2.js
#this will add factory and cars public keys in the smart contract
```

## Start a benchmark

```bash
#to start a benchmark give the total transaction limit and transaction per second
./bin/ws/send_v2.js 10000 100
#this will send 10k transactions at a 100tx/sec rate
```

## View using Polkadot Dashboard


```bash
docker run --rm -it --name polkadot-ui -e WS_URL=ws://substrate-ws.unice.cust.tasfrance.com -p 80:80 jacogr/polkadot-js-apps:latest
```
