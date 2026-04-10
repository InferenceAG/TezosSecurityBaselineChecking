#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../../_framework/init.sh"
. "$SCRIPT_DIR/../../_framework/functions.sh"

getTestcaseTitle

removeContract "selfTransfer"

case $1 in
	latest)
		echo "executing tests for $1"
        echo "Self transfer, success expected"
		_admin="$($TEZOSCLIENT list known addresses |grep admin |awk '{ print $2}')"
				
		$TEZOSCLIENT originate contract selfTransfer transferring 0 from deploy running selfTransfer.tz --burn-cap 1 --force >out.tmp 2>&1
		

		$TEZOSCLIENT transfer 1 from admin to selfTransfer >result.tmp 2>&1

		### The test should have triggered a gas exhaustion failure due to an infinite loop of self transactions
		oneTezPos=$(cat result.tmp |grep -n 'This transaction was successfully applied')

		if [ -z "$oneTezPos" ]; then
				echo "testcase failed"
				exit
		else
				echo "testcase succeeded"
		fi
		;;

	*)
		echo "not supported $1"
		;;	
		
esac
rm *.tmp
rm -rf compiled
