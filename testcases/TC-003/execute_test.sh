#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	jakarta)
		echo "executing tests for $1"
		# Latest version of ligo does not yet support "sub_mutez".
		# Thus, we are hacking the code for sake of the test case.

		# Vesting
		$LIGO compile contract vesting.ligo > vesting-ithaca.tz.tmp

		# Hack to patch
		sed -i 's/SUB ;/SUB_MUTEZ; ASSERT_SOME;/g' vesting-ithaca.tz.tmp

		initTezValue="8"
		initTez=$initTezValue"tez"
		adminAddress=$($TEZOSCLIENT list known addresses |grep admin | awk '{print $2}')

		storage=$($LIGO compile storage vesting.ligo "record[admin=(\"$adminAddress\":address);minLockedValue=4tez;balance=$initTez]")
		$TEZOSCLIENT originate contract reentrancy transferring 8 from deploy running vesting-ithaca.tz.tmp --init "$storage" --burn-cap 0.3 --force >out1.tmp 2>&1

		# Attacker
		tzaddress=$($TEZOSCLIENT list known addresses |grep deploy | awk '{print $2}')
		contract="$($TEZOSCLIENT list known contracts |grep reentrancy |awk '{ print $2}')"

		sed "s/VARdestination/$tzaddress/g" attackerContract.ligo | sed "s/VARcontract/$contract/g" > attackerContract.tmp.ligo
		$LIGO compile contract attackerContract.tmp.ligo > attackerContract.tz.tmp
		storage=$($LIGO compile storage attackerContract.ligo 'unit')

		$TEZOSCLIENT originate contract attacker transferring 8 from deploy running attackerContract.tz.tmp --init $storage --burn-cap 0.3 --force >out2.tmp 2>&1
 
		# Transfer
		attacker="$($TEZOSCLIENT list known contracts |grep attacker |awk '{ print $2}')"

		arg="(Pair 3000000 \"$attacker\")"

		$TEZOSCLIENT transfer 0 from admin to reentrancy --entrypoint 'payout' --arg "$arg" > result.tmp 2>&1

		checkResult result.tmp "At line 81 characters 54 to 62,"
		;;

	ithaca)
		echo "executing tests for $1"
		# Latest version of ligo does not yet support "sub_mutez".
		# Thus, we are hacking the code for sake of the test case.

		# Vesting
		$LIGO compile contract vesting.ligo > vesting-ithaca.tz.tmp

		# Hack to patch
		sed -i 's/SUB ;/SUB_MUTEZ; ASSERT_SOME;/g' vesting-ithaca.tz.tmp

		initTezValue="8"
		initTez=$initTezValue"tez"
		adminAddress=$($TEZOSCLIENT list known addresses |grep admin | awk '{print $2}')

		storage=$($LIGO compile storage vesting.ligo "record[admin=(\"$adminAddress\":address);minLockedValue=4tez;balance=$initTez]")
		$TEZOSCLIENT originate contract reentrancy transferring 8 from deploy running vesting-ithaca.tz.tmp --init "$storage" --burn-cap 0.3 --force >out1.tmp 2>&1

		# Attacker
		tzaddress=$($TEZOSCLIENT list known addresses |grep deploy | awk '{print $2}')
		contract="$($TEZOSCLIENT list known contracts |grep reentrancy |awk '{ print $2}')"

		sed "s/VARdestination/$tzaddress/g" attackerContract.ligo | sed "s/VARcontract/$contract/g" > attackerContract.tmp.ligo
		$LIGO compile contract attackerContract.tmp.ligo > attackerContract.tz.tmp
		storage=$($LIGO compile storage attackerContract.ligo 'unit')

		$TEZOSCLIENT originate contract attacker transferring 8 from deploy running attackerContract.tz.tmp --init $storage --burn-cap 0.3 --force >out2.tmp 2>&1
 
		# Transfer
		attacker="$($TEZOSCLIENT list known contracts |grep attacker |awk '{ print $2}')"

		arg="(Pair 3000000 \"$attacker\")"

		$TEZOSCLIENT transfer 0 from admin to reentrancy --entrypoint 'payout' --arg "$arg" > result.tmp 2>&1

		checkResult result.tmp "At line 83 characters 54 to 62,"
		;;

	kathmandu)
		echo "executing tests for $1"

		# Vesting
		$LIGO compile contract vesting.ligo > vesting.tz.tmp

		initTezValue="8"
		initTez=$initTezValue"tez"
		adminAddress=$($TEZOSCLIENT list known addresses |grep admin | awk '{print $2}')

		storage=$($LIGO compile storage vesting.ligo "record[admin=(\"$adminAddress\":address);minLockedValue=4tez;balance=$initTez]")
		$TEZOSCLIENT originate contract reentrancy transferring 8 from deploy running vesting.tz.tmp --init "$storage" --burn-cap 0.2165 --force >out1.tmp 2>&1

		# Attacker
		tzaddress=$($TEZOSCLIENT list known addresses |grep deploy | awk '{print $2}')
		contract="$($TEZOSCLIENT list known contracts |grep reentrancy |awk '{ print $2}')"

		sed "s/VARdestination/$tzaddress/g" attackerContract.ligo | sed "s/VARcontract/$contract/g" > attackerContract.tmp.ligo
		$LIGO compile contract attackerContract.tmp.ligo > attackerContract.tz.tmp
		storage=$($LIGO compile storage attackerContract.tmp.ligo 'unit')

		$TEZOSCLIENT originate contract attacker transferring 8 from deploy running attackerContract.tz.tmp --init $storage --burn-cap 0.146 --force >out2.tmp 2>&1
 
		# Transfer
		attacker="$($TEZOSCLIENT list known contracts |grep attacker |awk '{ print $2}')"

		arg="(Pair 3000000 \"$attacker\")"

		$TEZOSCLIENT transfer 0 from admin to reentrancy --entrypoint 'payout' --arg "$arg" > result.tmp 2>&1

		checkResult result.tmp "At line 81 characters 54 to 62,"
		;;

	*)
		echo "executing tests for $1"

		# Vesting
		$LIGO compile contract vesting.ligo > vesting.tz.tmp

		initTezValue="8"
		initTez=$initTezValue"tez"
		adminAddress=$($TEZOSCLIENT list known addresses |grep admin | awk '{print $2}')

		storage=$($LIGO compile storage vesting.ligo "record[admin=(\"$adminAddress\":address);minLockedValue=4tez;balance=$initTez]")
		$TEZOSCLIENT originate contract reentrancy transferring 8 from deploy running vesting.tz.tmp --init "$storage" --burn-cap 0.2165 --force >out1.tmp 2>&1

		# Attacker
		tzaddress=$($TEZOSCLIENT list known addresses |grep deploy | awk '{print $2}')
		contract="$($TEZOSCLIENT list known contracts |grep reentrancy |awk '{ print $2}')"

		sed "s/VARdestination/$tzaddress/g" attackerContract.ligo | sed "s/VARcontract/$contract/g" > attackerContract.tmp.ligo
		$LIGO compile contract attackerContract.tmp.ligo > attackerContract.tz.tmp
		storage=$($LIGO compile storage attackerContract.tmp.ligo 'unit')

		$TEZOSCLIENT originate contract attacker transferring 8 from deploy running attackerContract.tz.tmp --init $storage --burn-cap 0.146 --force >out2.tmp 2>&1
 
		# Transfer
		attacker="$($TEZOSCLIENT list known contracts |grep attacker |awk '{ print $2}')"

		arg="(Pair 3000000 \"$attacker\")"

		$TEZOSCLIENT transfer 0 from admin to reentrancy --entrypoint 'payout' --arg "$arg" > result.tmp 2>&1

		checkResult result.tmp "At line 29 characters 54 to 62,"
		;;
esac
rm *.tmp