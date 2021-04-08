# Benchmark pour sawtooth


# How to ?

First:
```bash
cd ./Hyperledger-Sawtooth/sawtooth-transaction-cpp/
```

1. Init new_car et new_owner une 1er fois lorsque la blockchain est "fresh" avec:
```bash
docker-compose -f docker-compose-sender.yaml down
docker-compose -f docker-compose-sender.yaml up send-init-cartp
docker-compose -f docker-compose-sender.yaml down
```
2. modifier `benchmark.py` pour le test désiré, exemple:
```json
    {
        "sender_parameters": {
            "limit": "1000",
            "js_nb_parallele": "3",
            "js_wait_time": "1"
        }
    },
```

3. executer `./benchmark.py`

