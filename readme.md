# Replica Guide
=============
To use: You'll want to bring your own more performant rpc url for the base chain instead of using the default. Configure this by `export L1_RPC_URL={YOUR BASE CHAIN RPC URL}`. Then run `make replica-up`. Syncing the replica from scratch might take up to a couple hours

A number of constants have already been set:
- Beacon chain API
- the sequencer http url, which allows for transactions sent to the replica node to be forwarded to the sequencer, effectively meaning you can use the replica node like a full rpc provider
- the p2p endpoint, which means that the replica can the latest blocks produced from a trusted source

To check on the sync status of the node:

    RPC_URL=http://localhost:7545
	curl $RPC_URL -X POST -H "Content-Type: application/json" --data \
	    '{"jsonrpc":"2.0","method":"optimism_syncStatus","params":[],"id":1}' | jq .


or `bash progress.sh`



Commands:
=========

    L1_RPC_URL={INSERT RPC URL} make replica-up

    make replica-down

    make replica-clean
