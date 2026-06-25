# Replica Guide for B3

Run a B3 mainnet replica with [docker-compose-reth.yml](docker-compose-reth.yml):

- **op-reth** `public.ecr.aws/i6b2w2n6/op-reth:v2.2.3`
- **op-node** `public.ecr.aws/i6b2w2n6/op-node:1.16.1-celestia-e9ec322-altda` ([AltDA mode](https://docs.optimism.io/builders/chain-operators/features/alt-da-mode))
- **op-alt-da** `public.ecr.aws/i6b2w2n6/op-alt-da:v0.15.0-4d9d54d` ([celestiaorg/op-alt-da](https://github.com/celestiaorg/op-alt-da))

Celestia namespace: `ca1de12a8c022bd46803` (29-byte v0 form in config: `00000000000000000000000000000000000000ca1de12a8c022bd46803`).

Bring your own Base mainnet RPC (`L1_RPC_URL`, chain id `8453`). The sequencer HTTP URL and P2P static peer are already configured so the replica can forward transactions and receive blocks from a trusted source.

## Reth datadir snapshot (recommended)

Download and extract into `./reth_data` before the first start. This snapshot includes proofs data under `proofs-db/`:

https://caldera-chain-data-snapshots.s3.us-west-2.amazonaws.com/exported-snapshots/bedrock-b3/bedrock-b3-reth-2026-Jun-24.tar

If you do not need historical eth proofs, you can delete `reth_data/proofs-db/` after extraction to save disk space. Remove these flags from `docker-compose-reth.yml` (`op-reth` service) as well:

```
--proofs-history --proofs-history.storage-path=/root/datadir/proofs-db --proofs-history.storage-version=v2 --rpc.eth-proof-window=1209600 --proofs-history.window=5184000
```

## Configure op-alt-da

Edit [op-alt-da-config.toml](op-alt-da-config.toml): set Celestia bridge gRPC URL and auth token for read-only access. Fallback S3 is configured with `mode = "read_fallback"` so the replica only reads from the public cache and does not attempt S3 writes.

## Run

```bash
cp .env.example .env   # set L1_RPC_URL
make replica-up
# or: export L1_RPC_URL=<base-rpc> && docker compose -f docker-compose-reth.yml up -d
```

Syncing from scratch without a snapshot can take a couple of hours.

## Sync status

Rollup sync status (default op-node port `17545`):

```bash
RPC_URL=http://localhost:17545
curl $RPC_URL -X POST -H "Content-Type: application/json" --data \
    '{"jsonrpc":"2.0","method":"optimism_syncStatus","params":[],"id":1}' | jq .
```

Or:

```bash
RPC_URL=http://localhost:17545 bash progress.sh
```

## Commands

```
L1_RPC_URL=<base-rpc> make replica-up

make replica-down
```

## Celestia upgrades

Please refer to celestia docs for network upgrades: https://docs.celestia.org/how-to-guides/participate#network-upgrades
