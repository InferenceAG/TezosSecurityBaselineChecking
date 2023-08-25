#!/bin/bash
. ../../../_framework/init.sh
. ../../../_framework/functions.sh

$LIGO compile contract zeroTezTransfer.mligo > zeroTezTransfer.tz

# copy
cp *.tz ../

# Clean up
rm -rf *.tmp