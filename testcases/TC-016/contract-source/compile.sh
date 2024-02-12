#!/bin/bash
. ../../../_framework/init.sh
. ../../../_framework/functions.sh

$LIGO compile contract storage_contract.mligo > storage_contract.tz

$LIGO compile contract implementation_contract.mligo > implementation_contract.tz

# copy
cp *.tz ../

# Clean up
rm -rf *.tmp