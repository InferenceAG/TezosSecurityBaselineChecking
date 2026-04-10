#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../../_framework/init.sh"
. "$SCRIPT_DIR/../../_framework/functions.sh"

getTestcaseTitle

removeContract "singleEP"
removeContract "twoEP_withDefault"
removeContract "twoEP_noDefault"

case $1 in
	latest)
		echo "executing tests for $1"
        echo "Single EP - Gas exhaustion expected"
		_admin="$($TEZOSCLIENT list known addresses |grep admin |awk '{ print $2}')"
				
		$TEZOSCLIENT originate contract singleEP transferring 0 from deploy running singleEP.tz --burn-cap 1 --force >out.tmp 2>&1
		

		$TEZOSCLIENT transfer 1 from admin to singleEP >result.tmp 2>&1

		### The test should have triggered a gas exhaustion failure due to an infinite loop of self transactions
		oneTezPos=$(cat result.tmp |grep -n 'Gas limit exceeded during typechecking or execution')

		if [ -z "$oneTezPos" ]; then
				echo "testcase failed"
				exit
		else
				echo "testcase succeeded"
		fi
		

        echo "Two EP, one default - No issue expected"
		_admin="$($TEZOSCLIENT list known addresses |grep admin |awk '{ print $2}')"
				
		$TEZOSCLIENT originate contract twoEP_withDefault transferring 0 from deploy running twoEP_withDefault.tz --burn-cap 0.2 --force >out.tmp 2>&1
		

		$TEZOSCLIENT transfer 1 from admin to twoEP_withDefault >result.tmp 2>&1

		### The test should run without any problem
		oneTezPos=$(cat result.tmp |grep -n 'This transaction was successfully applied')

		if [ -z "$oneTezPos" ]; then
				echo "testcase failed"
				exit
		else
				echo "testcase succeeded"
		fi
		

        echo "Two EP, no default - Failure expected"
		_admin="$($TEZOSCLIENT list known addresses |grep admin |awk '{ print $2}')"
				
		$TEZOSCLIENT originate contract twoEP_noDefault transferring 0 from deploy running twoEP_noDefault.tz --burn-cap 0.2 --force >out.tmp 2>&1
		

		$TEZOSCLIENT transfer 1 from admin to twoEP_noDefault >result.tmp 2>&1

		### The test should run without any problem
		oneTezPos=$(cat result.tmp |grep -n 'This operation FAILED.')

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
