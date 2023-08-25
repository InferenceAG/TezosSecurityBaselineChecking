#!/bin/bash
. ../../../_framework/init.sh
. ../../../_framework/functions.sh

$LIGO compile contract TezTransfer.mligo > TezTransfer.tz

# copy
cp *.tz ../

# Clean up
rm -rf *.tmp