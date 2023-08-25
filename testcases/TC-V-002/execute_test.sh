#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "rogue"

case $1 in
	oxford)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract rogue transferring 0 from deploy running rogue_dig.tz --init 'Unit' --force >result.tmp 2>&1
		checkResult result.tmp "At line 4 characters 26 to 31, wrong stack type for instruction DIG: []."
		;;
	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp