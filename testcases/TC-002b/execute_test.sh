#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "reentrancy"
removeContract "attacker"

case $1 in
	oxford)
		echo "executing tests for $1"

		# Vesting contract
		adminAddress=$($TEZOSCLIENT list known addresses |grep admin | awk '{print $2}')

		# ligo compile expression cameligo '{admin = ("tz1burnburnburnburnburnburnburjAYjjX" : address); minLockedAmount = 4tez}'
		storage="(Pair \"$adminAddress\" 4000000)"
		$TEZOSCLIENT originate contract reentrancy transferring 8 from deploy running vesting.tz --init "$storage" --burn-cap 0.3 --force >out1.tmp 2>&1
			
		# Attacker contract
		contract="$($TEZOSCLIENT list known contracts |grep reentrancy |awk '{ print $2}')"

		# ligo compile storage contract-source/attackerContract.mligo '{ dest = ("tz1burnburnburnburnburnburnburjAYjjX" : address); level = 0n }'
		storage="(Pair \"$contract\" 0)"
		$TEZOSCLIENT originate contract attacker transferring 0 from deploy running attackerContract.tz --init "$storage" --burn-cap 0.3 --force >out2.tmp 2>&1

		# Initialize transfer
		attacker="$($TEZOSCLIENT list known contracts |grep attacker |awk '{ print $2}')"

		arg="(Pair \"$attacker\" 3000000)"
		
		$TEZOSCLIENT transfer 0 from admin to reentrancy --entrypoint 'transfer' --arg "$arg" --burn-cap 1 > result.tmp 2>&1

		checkResult result.tmp "The operation has only been included 0 blocks ago."
		;;

	*)
		echo "not supported $1"
		;;	

esac
rm -rf *.tmp
