#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	ithaca)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract mutezUnderflow transferring 0 from deploy running mutezUnderflow-ithaca.tz --init '0' --burn-cap 0.5 --force >out.tmp 2>&1 
		$TEZOSCLIENT transfer 0 from deploy to mutezUnderflow --entrypoint "default" --arg 'Unit' >result.tmp 2>&1 
		checkResult result.tmp "At line 7 characters 9 to 20,"
		;;
	*)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract mutezUnderflow transferring 0 from deploy running mutezUnderflow.tz --init '0' --burn-cap 0.5 --force >out.tmp 2>&1 
		$TEZOSCLIENT transfer 0 from deploy to mutezUnderflow --entrypoint "default" --arg 'Unit' >result.tmp 2>&1 
		checkResult result.tmp "Underflowing subtraction of 0.000001 tez and 0.000002 tez"
		;;
esac
rm *.tmp