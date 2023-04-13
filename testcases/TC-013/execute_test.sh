#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
        echo "Self transfer, success expected"
		admin="$($TEZOSCLIENT list known addresses |grep admin |awk '{ print $2}')"
				
		$TEZOSCLIENT originate contract selfTransfer transferring 0 from deploy running selfTransfer.tz --burn-cap 1 --force >out.tmp 2>&1
		

		$TEZOSCLIENT transfer 1 from admin to selfTransfer >result.tmp 2>&1

		### The test should have triggered a gas exhaustion failure due to an infinite loop of self transactions
		oneTezPos=$(cat result.tmp |grep -n 'This transaction was successfully applied')

		if [ -z "$oneTezPos" ]; then
				echo "testcase failed"
				exit
		else
				echo "testcase Succeeded"
		fi
		
esac
rm *.tmp
rm -rf compiled
