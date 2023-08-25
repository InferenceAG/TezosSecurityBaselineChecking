#!/bin/bash
. ../../../_framework/init.sh
. ../../../_framework/functions.sh

# Vesting contract
$LIGO compile contract vesting.mligo > vesting.tz

# Attacker contract
$LIGO compile contract attackerContract.mligo > attackerContract.tz


# copy
cp *.tz ../

# Clean up
rm -rf *.tmp