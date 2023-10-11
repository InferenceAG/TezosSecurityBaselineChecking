#!/bin/bash
. ../../../_framework/init.sh
. ../../../_framework/functions.sh

$LIGO compile contract tezSender.mligo > tezSender.tz


# copy
cp *.tz ../

# Clean up
rm -rf *.tmp