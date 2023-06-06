#!/bin/bash -u

NETWORK_ENV_FILE='./network/.env'
TIMESTAMP=$(date +%s)

mkdir -p results

for NODES_NUMBER in 7 14 21 28; do
  sed -i 's/NODES_NUMBER=.*/NODES_NUMBER='$NODES_NUMBER'/' $NETWORK_ENV_FILE
  for CONSENSUS_ALGO in qbft ibft raft clique; do
    sed -i 's/GOQUORUM_CONS_ALGO=.*/GOQUORUM_CONS_ALGO='$CONSENSUS_ALGO'/' $NETWORK_ENV_FILE
    cd ./network || exit 1
    ./run.sh
    sleep 5 # wait for network to init
    cd ..
    for TYPE in public private; do
      for TPS in 50 100 150 200 250 300; do
        sed -i 's/tps:.*/tps: '$TPS'/' ./caliper/benchmarks/scenario/bank-"$TYPE"/config.yaml
        echo "Executing benchmark with $NODES_NUMBER, $CONSENSUS_ALGO, $TPS, $TYPE"

        cd ./caliper || exit 1
        if [[ "$TYPE" = "public" ]]; then
          npm run launch-bank-public
        else
          npm run launch-bank-private-"$NODES_NUMBER"-nodes
        fi

        cd ..
        cp ./caliper/report.html ./results/report-$NODES_NUMBER-$CONSENSUS_ALGO-$TYPE-$TPS-"$TIMESTAMP".html
        echo "Benchmark ran successfully"
        sleep 5 # ensure network is not processing previous test
      done
    done
    cd ./network || exit 1
    ./remove.sh
    cd ..
  done
done
