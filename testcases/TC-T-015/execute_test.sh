#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "getter"

case $1 in
	oxford)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract getter transferring 0 from deploy running tickets_lambda.tz --init 'Unit' --force >result.tmp 2>&1
		checkResult result.tmp "is not compatible with type option (ticket string)."
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp