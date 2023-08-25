#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "mutezOverflow"

case $1 in
	oxford)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract mutezOverflow transferring 0 from deploy running mutezOverflow.tz --init '0' --burn-cap 0.08325 --force >out.tmp 2>&1 
		$TEZOSCLIENT transfer 0 from deploy to mutezOverflow --entrypoint "default" --arg 'Unit' >result.tmp 2>&1 
		checkResult result.tmp "Overflowing multiplication of 1000 tez and 10000000000"
		;;
	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp