#!/bin/bash


INFLUX_URL=https://influxdb.unice.cust.tasfrance.com
INFLUX_USER=admin
INFLUX_PWD=admin
INFLUX_DB=metrics
DATA_PATH=datas

echo "Start"

rm -rf $DATA_PATH
mkdir -p $DATA_PATH

NOW=$(date +%s%N | cut -b1-13)
START_TS=1618508327940
END_TS=1618514773553 #$NOW
GROUP_BY_TIME="60s" #in seconds
timeFilter="time >= ${START_TS}ms and time <= ${END_TS}ms "

#Note:
# Use allways "as mean" alias to make python script later simple to find the data column for each table
#

####
# field="sawtooth_validator.chain.ChainController.block_num"
# QUERY="SELECT mean(\"value\") FROM \"$field\" WHERE $timeFilter GROUP BY time($GROUP_BY_TIME) fill(none)" #, \"host\"
# response=$(curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv")
# echo "$response" > "$DATA_PATH/$field/$i.csv"
####
field="sawtooth_validator.chain.ChainController.committed_transactions_gauge"
QUERY="SELECT mean(\"value\") FROM \"$field\" WHERE $timeFilter GROUP BY time($GROUP_BY_TIME) fill(null)" #, \"host\"
# echo $QUERY
curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv" > "$DATA_PATH/$field.csv"
####
field="sawtooth_validator.executor.TransactionExecutorThread.tp_process_response_count"
QUERY="SELECT (non_negative_derivative(percentile(\"count\", 99.9), 10s) /10) as mean FROM \"$field\" WHERE  $timeFilter GROUP BY time($GROUP_BY_TIME) fill(null)" #, \"host\"  (\"response_type\" = 'OK') AND
# echo $QUERY
curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv" > "$DATA_PATH/$field.csv"
####
field="sawtooth_validator.publisher.BlockPublisher.pending_batch_gauge"
QUERY="SELECT mean(\"value\") FROM \"$field\" WHERE  $timeFilter GROUP BY time($GROUP_BY_TIME) fill(null)" #, \"host\"  (\"response_type\" = 'OK') AND
curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv" > "$DATA_PATH/$field.csv"
####
field="sawtooth_validator.chain.ChainController.blocks_considered_count"
QUERY="SELECT mean(\"count\") as mean FROM \"$field\" WHERE  $timeFilter GROUP BY time($GROUP_BY_TIME) fill(null)" #, \"host\"  (\"response_type\" = 'OK') AND
curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv" > "$DATA_PATH/$field.csv"
####
field="sawtooth_validator.back_pressure_handlers.ClientBatchSubmitBackpressureHandler.backpressure_batches_rejected_gauge"
QUERY="SELECT (non_negative_derivative(sum(\"value\"), 10s) /10) as mean FROM \"$field\" WHERE  $timeFilter GROUP BY time($GROUP_BY_TIME) fill(null)" #, \"host\"  (\"response_type\" = 'OK') AND
curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv" > "$DATA_PATH/$field.csv"
####
field="sawtooth_rest_api.post_batches_count"
QUERY="SELECT (non_negative_derivative(sum(\"count\"), 10s) /10) as mean FROM \"$field\" WHERE  $timeFilter GROUP BY time($GROUP_BY_TIME) fill(null)" #, \"host\"  (\"response_type\" = 'OK') AND
curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv" > "$DATA_PATH/$field.csv"
####
#unsure here:
# field="sawtooth_rest_api.post_batches_validator_time"
# QUERY="SELECT (non_negative_derivative(mean(\"sum\"), 10s) /10) as mean FROM \"$field\" WHERE  $timeFilter GROUP BY time($GROUP_BY_TIME) fill(null)" #, \"host\"  (\"response_type\" = 'OK') AND
# curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv" > "$DATA_PATH/$field.csv"
####
field="sawtooth_validator.interconnect.Interconnect.send_response_time"
QUERY="SELECT (non_negative_derivative(sum(\"count\"), 10s) /10) as mean FROM \"$field\" WHERE  $timeFilter GROUP BY time($GROUP_BY_TIME) fill(null)" #, \"host\"  (\"response_type\" = 'OK') AND
curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv" > "$DATA_PATH/$field.csv"
####
field="sawtooth_validator.interconnect._SendReceive.received_message_count"
QUERY="SELECT (non_negative_derivative(sum(\"count\"), 10s) /10) as mean FROM \"$field\" WHERE  $timeFilter GROUP BY time($GROUP_BY_TIME) fill(null)" #, \"host\"  (\"response_type\" = 'OK') AND
curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv" > "$DATA_PATH/$field.csv"
####

echo "*******"
echo "Done"