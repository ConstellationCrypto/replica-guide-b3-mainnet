# Replica Guide for B3
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

## Snapshot:
https://constellationlabs-dashboard-beta.s3.us-west-2.amazonaws.com/b3/Jul_1_2025_b3_geth_data.tar

## Commands:
```
    L1_RPC_URL={INSERT RPC URL} make replica-up

    make replica-down

    make replica-clean
```

## op-reth replica (AltDA)

Uses [docker-compose-reth.yml](docker-compose-reth.yml) with:

- **op-reth** `public.ecr.aws/i6b2w2n6/op-reth:v2.2.3`
- **op-node** `public.ecr.aws/i6b2w2n6/op-node:1.16.1-celestia-e9ec322-altda` ([AltDA mode](https://docs.optimism.io/builders/chain-operators/features/alt-da-mode))
- **op-alt-da** `public.ecr.aws/i6b2w2n6/op-alt-da:v0.15.0-4d9d54d` ([celestiaorg/op-alt-da](https://github.com/celestiaorg/op-alt-da))

Celestia namespace: `ca1de12a8c022bd46803` (29-byte v0 form in config: `00000000000000000000000000000000000000ca1de12a8c022bd46803`).

### Reth datadir

Extract chain data into `./reth_data` before the first start. A dedicated reth snapshot may be published later; until then you can sync from scratch or reuse an existing reth export if you have one.

If you do not need proofs, remove these flags from `docker-compose-reth.yml` (`op-reth` service):

```
--proofs-history --proofs-history.storage-path=/root/datadir/proofs-db --proofs-history.storage-version=v2 --rpc.eth-proof-window=1209600 --proofs-history.window=5184000
```

and delete `reth_data/proofs-db`.

### Configure op-alt-da

Edit [op-alt-da-config.toml](op-alt-da-config.toml): set Celestia bridge gRPC URL and auth token for read-only access. Fallback S3 is configured with `mode = "read_fallback"` so the replica only reads from the public cache and does not attempt S3 writes.

### Run

`L1_RPC_URL` must point at Base mainnet (chain id `8453`).

```bash
cp .env.example .env   # set L1_RPC_URL
make reth-up
# or: export L1_RPC_URL=<base-rpc> && docker compose -f docker-compose-reth.yml up -d
```

Rollup sync status (default op-node port `17545`):

```bash
RPC_URL=http://localhost:17545 bash progress.sh
```

    make reth-down

## Celestia upgrades
Please refer to celestia docs for network upgrades: https://docs.celestia.org/how-to-guides/participate#network-upgrades
