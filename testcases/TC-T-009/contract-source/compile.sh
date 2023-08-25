#!/bin/bash
. ../../../_framework/init.sh
. ../../../_framework/functions.sh

$LIGO compile contract caller.mligo > caller.tz


# copy
cp *.tz ../

# Clean up
rm -rf *.tmp