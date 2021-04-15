#!/bin/bash


INFLUX_URL=https://influxdb.unice.cust.tasfrance.com
INFLUX_USER=admin
INFLUX_PWD=admin
INFLUX_DB=metrics
DATA_PATH=datas

echo "Start"

rm -rf $DATA_PATH
mkdir -p $DATA_PATH

# echo "List of DATABASES"
# QUERY="SHOW DATABASES"
# curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "q=$QUERY" -H "Accept: application/csv"
# echo "*******"



NOW=$(date +%s%N | cut -b1-13)
START_TS=1618494133288
END_TS=$NOW
INTERVAL=120 #in seconds
GROUP_BY_TIME="60s" #in seconds
COUNTER=0
FIELDS="sawtooth_validator.chain.ChainController.block_num sawtooth_validator.chain.ChainController.committed_transactions_gauge sawtooth_validator.executor.TransactionExecutorThread.tp_process_response_count"
INTERVAL=$(($INTERVAL *1000))
TOTAL=$((($END_TS-$START_TS) / $INTERVAL))
# for i in $(seq $START_TS $INTERVAL $END_TS)
# do
#     for field in $FIELDS; do
#         mkdir -p "$DATA_PATH/$field"
#     done 
#     tmp=$(($i+$INTERVAL))
#     timeFilter="time >= ${i}ms and time <= ${tmp}ms "

#     ####
#     # field="sawtooth_validator.chain.ChainController.block_num"
#     # QUERY="SELECT mean(\"value\") FROM \"$field\" WHERE $timeFilter GROUP BY time($GROUP_BY_TIME) fill(none)" #, \"host\"
#     # response=$(curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv")
#     # echo "$response" > "$DATA_PATH/$field/$i.csv"
#     ####
#     field="sawtooth_validator.chain.ChainController.committed_transactions_gauge"
#     QUERY="SELECT mean(\"value\") FROM \"$field\" WHERE $timeFilter GROUP BY time($GROUP_BY_TIME) fill(null)" #, \"host\"
#     curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv" > "$DATA_PATH/$field/$i.csv"
#     ####
#     field="sawtooth_validator.executor.TransactionExecutorThread.tp_process_response_count"
#     QUERY="SELECT non_negative_derivative(mean(\"count\"), 10s) /10 FROM \"$field\" WHERE  $timeFilter GROUP BY time($GROUP_BY_TIME) fill(null)" #, \"host\"  (\"response_type\" = 'OK') AND
#     curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv" > "$DATA_PATH/$field/$i.csv"
#     ####


#     ((COUNTER++))
#     echo "$(($COUNTER *100 / $TOTAL))%"
# done


############## remove useless interval loop

for field in $FIELDS; do
    mkdir -p "$DATA_PATH/$field"
done 

timeFilter="time >= ${START_TS}ms and time <= ${END_TS}ms "

####
# field="sawtooth_validator.chain.ChainController.block_num"
# QUERY="SELECT mean(\"value\") FROM \"$field\" WHERE $timeFilter GROUP BY time($GROUP_BY_TIME) fill(none)" #, \"host\"
# response=$(curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv")
# echo "$response" > "$DATA_PATH/$field/$i.csv"
####
field="sawtooth_validator.chain.ChainController.committed_transactions_gauge"
QUERY="SELECT mean(\"value\") FROM \"$field\" WHERE $timeFilter GROUP BY time($GROUP_BY_TIME) fill(null)" #, \"host\"
curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv" > "$DATA_PATH/$field.csv"
####
field="sawtooth_validator.executor.TransactionExecutorThread.tp_process_response_count"
QUERY="SELECT (non_negative_derivative(mean(\"count\"), 10s) /10) as mean FROM \"$field\" WHERE  $timeFilter GROUP BY time($GROUP_BY_TIME) fill(null)" #, \"host\"  (\"response_type\" = 'OK') AND
curl -sS --insecure -u $INFLUX_USER:$INFLUX_PWD -XPOST "$INFLUX_URL/query" --data-urlencode "db=$INFLUX_DB" --data-urlencode "q=$QUERY" -H "Accept: application/csv" > "$DATA_PATH/$field.csv"
####

echo "*******"
echo "Done"