#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "mutezUnderflow"

case $1 in
	oxford)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract mutezUnderflow transferring 0 from deploy running mutezUnderflow-ithaca.tz --init '0' --burn-cap 0.5 --force >out.tmp 2>&1 
		$TEZOSCLIENT transfer 0 from deploy to mutezUnderflow --entrypoint "default" --arg 'Unit' >result.tmp 2>&1 
		checkResult result.tmp "At line 7 characters 9 to 20,"
		;;
	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp