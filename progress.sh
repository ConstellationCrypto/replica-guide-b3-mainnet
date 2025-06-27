#!/usr/bin/bash

# Load Environment Variables
if [ -f .env ]; then
  export $(cat .env | grep -v '#' | sed 's/\r$//' | awk '/=/ {print $1}' )
fi

export ETH_RPC_URL=http://localhost:8545

L2_URL=https://b3.calderachain.xyz/http

T0=`cast block-number --rpc-url $ETH_RPC_URL` ; sleep 10 ; T1=`cast block-number --rpc-url $ETH_RPC_URL`
PER_MIN=`expr $T1 - $T0`
PER_MIN=`expr $PER_MIN \* 6`
echo Blocks per minute: $PER_MIN


if [ $PER_MIN -eq 0 ]; then
    echo Not syncing
    exit;
fi


# How many more blocks do we need?
HEAD=`cast block-number --rpc-url $L2_URL`
BEHIND=`expr $HEAD - $T1`
MINUTES=`expr $BEHIND / $PER_MIN`
HOURS=`expr $MINUTES / 60`

if [ $MINUTES -le 60 ] ; then
   echo Minutes until sync completed: $MINUTES
fi

if [ $MINUTES -gt 60 ] ; then
   echo Hours until sync completed: $HOURS
fi

if [ $HOURS -gt 24 ] ; then
   DAYS=`expr $HOURS / 24`
   echo Days until sync complete: $DAYS
fi