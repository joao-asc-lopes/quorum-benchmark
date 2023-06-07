#!/bin/bash -u

NETWORK_ENV_FILE='./network/.env'
TIMESTAMP=$(date +%s)

RESULTS_DIR=./results/"$TIMESTAMP"

mkdir -p "$RESULTS_DIR"

for NODES_NUMBER in 7 12 17 22; do
  sed -i 's/NODES_NUMBER=.*/NODES_NUMBER='$NODES_NUMBER'/' $NETWORK_ENV_FILE
  for CONSENSUS_ALGO in raft clique ibft qbft; do
    sed -i 's/GOQUORUM_CONS_ALGO=.*/GOQUORUM_CONS_ALGO='$CONSENSUS_ALGO'/' $NETWORK_ENV_FILE
    for TYPE in public private; do
      for TPS in 50 100 150 200 250 300; do
        cd ./network || exit 1
        ./run.sh
        cd ..
        sleep 120 # wait for network to init
        sed -i 's/tps:.*/tps: '$TPS'/' ./caliper/benchmarks/scenario/bank-"$TYPE"/config.yaml
        echo "Executing benchmark with $NODES_NUMBER, $CONSENSUS_ALGO, $TPS, $TYPE"

        cd ./caliper || exit 1
        if [[ "$TYPE" = "public" ]]; then
          npm run launch-bank-public
        else
          npm run launch-bank-private-"$NODES_NUMBER"-nodes
        fi

        cd ..
        cp ./caliper/report.html "$RESULTS_DIR"/report-$CONSENSUS_ALGO-$NODES_NUMBER-$TYPE-$TPS.html
        cd ./network || exit 1
        ./remove.sh
        cd ..
        echo "Benchmark ran successfully"
      done
    done
  done
done
