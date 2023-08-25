#!/bin/bash
. ../../../_framework/init.sh
. ../../../_framework/functions.sh

$LIGO compile contract ordering.mligo > ordering.tz

# copy
cp *.tz ../

# Clean up
rm -rf *.tmp