# Remote control ubuntu machine in cloud


## First login to rancher

Use:
```bash
./login_remote.sh <RANCHER TOKEN>
```

## Run a command in the cloud

Use:
```bash
./cmd_remote.sh <your command>
```

Example:
```bash
./cmd_remote.sh "apt update && apt-get install -y git"

#use with a file
./cmd_remote.sh "$(cat init_remote_script.sh)"

#a full test in one line:
./cmd_remote.sh "$(cat init_remote_script.sh)"; sleep 18; ./cmd_remote.sh "./bin/ws/send_v2.js 50000 2000 20"
```
