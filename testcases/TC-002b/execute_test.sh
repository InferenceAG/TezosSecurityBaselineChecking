#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"

		# Vesting contract
		$LIGO compile contract vesting.ligo > vesting.tz.tmp
		adminAddress=$($TEZOSCLIENT list known addresses |grep admin | awk '{print $2}')

		storage=$($LIGO compile storage vesting.ligo "record[admin=(\"$adminAddress\":address);minLockedValue=4tez]")
		$TEZOSCLIENT originate contract reentrancy transferring 8 from deploy running vesting.tz.tmp --init "$storage" --burn-cap 0.3 --force >out1.tmp 2>&1
			
		# Attacker contract
		tzaddress=$($TEZOSCLIENT list known addresses |grep deploy | awk '{print $2}')
		contract="$($TEZOSCLIENT list known contracts |grep reentrancy |awk '{ print $2}')"

		sed "s/VARcontract/$contract/g" attackerContract.ligo > attackerContract.tmp.ligo
		$LIGO compile contract attackerContract.tmp.ligo > attackerContract.tz.tmp
		storage=$($LIGO compile storage attackerContract.tmp.ligo '0n')
		$TEZOSCLIENT originate contract attacker transferring 0 from deploy running attackerContract.tz.tmp --init $storage --burn-cap 0.3 --force >out2.tmp 2>&1

		# Initialize transfer
		attacker="$($TEZOSCLIENT list known contracts |grep attacker |awk '{ print $2}')"

		arg="(Pair \"$attacker\" 3000000)"
		
		$TEZOSCLIENT transfer 0 from admin to reentrancy --entrypoint 'transfer' --arg "$arg" --burn-cap 1 > result.tmp 2>&1

		checkResult result.tmp "The operation has only been included 0 blocks ago."
		;;

esac
rm *.tmp
