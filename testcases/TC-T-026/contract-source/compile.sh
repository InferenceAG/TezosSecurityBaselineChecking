#!/bin/bash
. ../../../_framework/init.sh
. ../../../_framework/functions.sh

$LIGO compile contract ticketSender.mligo > ticketSender.tz


# copy
cp *.tz ../

# Clean up
rm -rf *.tmp