# Quorum benchmark

Run a set of benchmarks for `goquorum` run using Hyperledger Caliper, under different configurations.

## Structure

- `caliper` directory contains the code for a custom Hyperledger Caliper connector to interact with a `goquorum` SUT.
- `network` contains the configurations for the networks.
  - `goquorum` networks can be individually brought up and down using the provided scripts.

## Usage

- Ensure docker is installed and running on the system
- Install all npm dependencies on `caliper` and `caliper/connector`
- `./run-all.sh`


## Configure

- By default, benchmarks for clique, raft, ibft and qbft are run on networks of 7, 12, 17 and 22 nodes, using both private and public transactions.
- These can be re-configured by altering the `run-all.sh` script.
- Networks with different configurations can be added to `network/X-nodes` by following the same structure.
  - [quorum-genesis-tool](https://github.com/ConsenSys/quorum-genesis-tool) is recommended to generate new network configurations.
  - To test private transactions on new networks, a network configuration file for it must also be added to `caliper/benchmarks/scenario/bank-private/network-Xnodes.json`, and an entry to call this script must be added to `caliper/package.json`.
- New benchmark scenarios can also be added. The one included is the smallbank one from Hyperledger Caliper examples.
- By default, a pumba instance is configured to introduce network latency to validator nodes at random.
  - This can be disabled by removing or commenting out the pumba service in `network/docker-compose.common.yml`.
