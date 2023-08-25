#!/bin/bash
. ../../../_framework/init.sh
. ../../../_framework/functions.sh

$LIGO compile contract addition.mligo > addition.tz

# copy
cp *.tz ../

# Clean up
rm -rf *.tmp