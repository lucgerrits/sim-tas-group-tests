#!/bin/bash

INFLUX_URL=https://influxdb.unice.cust.tasfrance.com/
INFLUX_USER=admin
INFLUX_PWD=admin
INFLUX_DB=metrics

CURL_CMD="curl --insecure -u $INFLUX_USER:$INFLUX_PWD -v"

echo "Start"

$CURL_CMD -XGET "$INFLUX_URL/ping"

# curl -XPOST "$INFLUX_URL/api/v2/query?pretty=true" -sS \
#     -H 'Accept:application/csv' \
# SELECT mean("value") FROM "sawtooth_validator.chain.ChainController.committed_transactions_gauge" WHERE $timeFilter GROUP BY time($__interval), "host" fill(none)

echo "Done"