**State**: Working but need to fix batch sending issue.
# substrate-transaction-js

Javascript client for Substrate.

## Dependencies

- polkadot-api


## Build & installation

```bash
npm install
npm run-script build
#Build two scripts:
#-> Init blockchain: init.js
#-> Send crashes: send.js
```

## Init blockchain

## Start

```bash
npm start

#or build
npm run-script build
node ./out.js
```

## View using Polkadot Dashboard


```bash
docker run --rm -it --name polkadot-ui -e WS_URL=ws://substrate-ws.unice.cust.tasfrance.com -p 80:80 jacogr/polkadot-js-apps:latest
```
