#!/bin/bash
. ../../../_framework/init.sh
. ../../../_framework/functions.sh

$LIGO compile contract callRollup.mligo > callRollup.tz


# copy
cp *.tz ../

# Clean up
rm -rf *.tmp