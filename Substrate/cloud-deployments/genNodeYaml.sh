#!/bin/bash

#list of validators available
#Max 6 validator for the moment
accountArray=('alice' 'bob' 'charlie' 'dave' 'eve' 'ferdie')

cat << EOF
apiVersion: v1
kind: List

items:

EOF

for i in {0..5}
do
   echo ""
   echo "# --------------------------=== POD DEPLOYMENT $i ===--------------------------"

    if [[ "$i" -eq 0 ]]; then
    #first node is bootnode

cat << EOF
- apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: node-$i
    namespace: substrate-net
  spec:
    replicas: 1
    selector:
      matchLabels:
        name: substrate-$i
    template:
      metadata:
        labels:
          name: substrate-$i
          serviceSelector: substrate-node
      spec:
        securityContext:
          fsGroup: 101
        containers:
          - name: substrate-node
            image: projetsim/substrate-sim:latest
            resources:
              requests:
                memory: "10Gi"
                #cpu: "0.5"
                ephemeral-storage: "1500Mi"
              limits:
                memory: "11Gi"
                #cpu: "1.1"
                ephemeral-storage: "2Gi"
            ports:
              - name: p2p
                containerPort: 30333
              - name: websocket
                containerPort: 9944
              - name: rpc
                containerPort: 9933
              - name: prometheus
                containerPort: 9615
            # envFrom:
            #   - configMapRef:
            #       name: keys-config
            command:
              - bash
            args:
              - -c
              - |
                    # Start Alice's node
                    RUST_LOG=runtime=debug
                    node-template \\
                        --base-path /tmp/peer-data \\
                        --chain local \\
                        --${accountArray[i]} \\
                        --port 30333 \\
                        --ws-port 9944 \\
                        --rpc-port 9933 \\
                        --node-key 0000000000000000000000000000000000000000000000000000000000000001 \\
                        --unsafe-ws-external \\
                        --unsafe-rpc-external \\
                        --rpc-cors=all \\
                        --prometheus-external \\
                        --log info \\
                        --validator 
                    
            volumeMounts:
              - name: sawtooth-data-$i
                mountPath: /tmp/peer-data

        volumes:
          - name: sawtooth-data-$i
            persistentVolumeClaim:
            claimName: sawtooth-data-$i
EOF

    else
    #than we have all other nodes

cat << EOF
- apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: node-$i
    namespace: substrate-net
  spec:
    replicas: 1
    selector:
      matchLabels:
        name: substrate-$i
    template:
      metadata:
        labels:
          name: substrate-$i
          serviceSelector: substrate-node
      spec:
        securityContext:
          fsGroup: 101
        containers:
          - name: substrate-node
            image: projetsim/substrate-sim:latest
            resources:
              requests:
                memory: "10Gi"
                #cpu: "0.5"
                ephemeral-storage: "1500Mi"
              limits:
                memory: "11Gi"
                #cpu: "1.1"
                ephemeral-storage: "2Gi"
            ports:
              - name: p2p
                containerPort: 30333
              - name: websocket
                containerPort: 9944
              - name: rpc
                containerPort: 9933
              - name: prometheus
                containerPort: 9615
            # envFrom:
            #   - configMapRef:
            #       name: keys-config
            command:
              - bash
            args:
              - -c
              - |
                    RUST_LOG=runtime=debug
                    node-template \\
                        --base-path /tmp/peer-data \\
                        --chain local \\
                        --${accountArray[i]} \\
                        --port 30333 \\
                        --ws-port 9944 \\
                        --rpc-port 9933 \\
                        --unsafe-ws-external \\
                        --unsafe-rpc-external \\
                        --rpc-cors=all \\
                        --prometheus-external \\
                        --log info \\
                        --validator \\
                        --bootnodes /ip4/\$SUBSTRATE_0_SERVICE_HOST/tcp/30333/p2p/12D3KooWEyoppNCUx8Yx66oV9fJnriXwCcXwDDUA2kj6vnc6iDEp
                    
            volumeMounts:
              - name: sawtooth-data-$i
                mountPath: /tmp/peer-data

        volumes:
          - name: sawtooth-data-$i
            persistentVolumeClaim:
            claimName: sawtooth-data-$i
EOF

fi # end if

# define service for node
cat << EOF

#---------------------------------=NODES SERVICES $i=---------------------------------------
- apiVersion: v1
  kind: Service
  metadata:
    name: substrate-$i
    namespace: substrate-net
  spec:
    type: ClusterIP
    selector:
      name: substrate-$i
    ports:
      - name: "30333"
        protocol: TCP
        port: 30333
        targetPort: 30333
      - name: "9944"
        protocol: TCP
        port: 9944
        targetPort: 9944
      - name: "9933"
        protocol: TCP
        port: 9933
        targetPort: 9933
      - name: "9615"
        protocol: TCP
        port: 9615
        targetPort: 9615
EOF

# define volume for node
cat << EOF
#---------------------------------=NODES PERSISTANT VOLUME $i=---------------------------------------
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: substrate-$i
    labels:
      type: local
  spec:
    storageClassName: manual
    capacity:
      storage: 50Gi
    accessModes:
      - ReadWriteOnce
    persistentVolumeReclaimPolicy: Recycle
    hostPath:
      path: "/datas/substrate-$i"
EOF

# define volume claim for node
cat << EOF
#--------------------------=PERSISTENT VOLUME CLAIM $i=------------------------------

- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    labels:
      app: substrate-data
    name: substrate-data-$i
    namespace: substrate-net
  spec:
    storageClassName: manual
    accessModes:
    - ReadWriteOnce
    resources:
     requests:
        storage: 45Gi
EOF


done # end for loop

cat << EOF

#--------------------------=ONE SERVICE FOR ALL NODE (websocket)=--------------------------------

- apiVersion: v1
  kind: Service
  metadata:
    name: substrate-ws-service
    namespace: substrate-net
  spec:
    type: ClusterIP
    selector:
      serviceSelector: substrate-node
    ports:
      - name: "9944"
        protocol: TCP
        port: 9944
        targetPort: 9944
EOF
