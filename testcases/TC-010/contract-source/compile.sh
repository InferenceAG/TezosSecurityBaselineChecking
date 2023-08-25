#!/bin/bash
. ../../../_framework/init.sh
. ../../../_framework/functions.sh

$LIGO compile contract calculations.mligo > calculations.tz


# copy
cp *.tz ../

# Clean up
rm -rf *.tmp