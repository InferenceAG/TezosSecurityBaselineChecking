#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "reentrancy"
removeContract "attacker"

case $1 in
	oxford)
		echo "executing tests for $1"

		# Vestiong contract
		adminAddress=$($TEZOSCLIENT list known addresses |grep admin | awk '{print $2}')
		storage="(Pair \"$adminAddress\" 4000000)"
		$TEZOSCLIENT originate contract reentrancy transferring 8 from deploy running vesting.tz --init "$storage" --burn-cap 0.3 --force >out1.tmp 2>&1

			
		# Attacker contract
		tzaddress=$($TEZOSCLIENT list known addresses |grep deploy | awk '{print $2}')
		contract="$($TEZOSCLIENT list known contracts |grep reentrancy |awk '{ print $2}')"

		# example: ligo compile storage contract-source/attackerContract.mligo '{ dest_address = ("tz1burnburnburnburnburnburnburjAYjjX": address); dest_contract = ("tz1burnburnburnburnburnburnburjAYjjX":address)}
		storage="(Pair \"$tzaddress\" \"$contract\")"
		$TEZOSCLIENT originate contract attacker transferring 8 from deploy running attackerContract.tz --init "$storage" --burn-cap 0.3 --force >out2.tmp 2>&1

				
		# Initialize transfer
		attacker="$($TEZOSCLIENT list known contracts |grep attacker |awk '{ print $2}')"

		arg="(Pair 3000000 \"$attacker\")"

		$TEZOSCLIENT transfer 0 from admin to reentrancy --entrypoint 'payout' --arg "$arg" > result.tmp 2>&1

		checkResult result.tmp "with \"Assert failure - Min locked value not ensured.\""
		
		;;	

	*)
		echo "not supported $1"
		;;	

esac
rm *.tmp
