#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		$SMARTPY compile ordering.py compiled/ --purge
		storage=$(cat ./compiled/order/step_000_cont_0_storage.tz)
		$TEZOSCLIENT originate contract ordering_external_lambda transferring 6 from deploy running ./compiled/order/step_000_cont_0_contract.tz --init $storage --burn-cap 0.2 --force >out.tmp 2>&1
		
		# CONS is prepending an item to a list.
		# Thus, the generated list of operations from the lambda is: { tez_1_transfer; tez_2_transfer; tez_3_transfer }
		lambda="{DROP; PUSH address myDestination; CONTRACT unit; IF_NONE { FAIL;} {}; PUSH mutez 3000000; UNIT; TRANSFER_TOKENS; NIL operation; SWAP; CONS; PUSH address myDestination; CONTRACT unit; IF_NONE { FAIL;} {}; PUSH mutez 2000000; UNIT; TRANSFER_TOKENS; CONS; PUSH address myDestination; CONTRACT unit; IF_NONE { FAIL;} {}; PUSH mutez 1000000; UNIT; TRANSFER_TOKENS; CONS;}"
		admin=""\"$($TEZOSCLIENT list known addresses |grep admin |awk '{ print $2}')\"""

		lambdaAddr=$(echo $lambda | sed "s/myDestination/$admin/g")
		#echo $lambdaAddr

		$TEZOSCLIENT transfer 0 from admin to ordering_external_lambda --entrypoint 'default' --arg "$lambdaAddr" >result.tmp 2>&1

		### Note!!!
		### The test is also successful, if the transaction fails, since the following check does verify whether also failed operations are in the correct order.
		### Could be improved...
		oneTezPos=$(cat result.tmp |grep -n 'Amount: ꜩ1' | awk -F ':' '{ print $1 }')
		twoTezPos=$(cat result.tmp |grep -n 'Amount: ꜩ2' | awk -F ':' '{ print $1 }')
		threeTezPos=$(cat result.tmp |grep -n 'Amount: ꜩ3' | awk -F ':' '{ print $1 }')

		if [ -z "$oneTezPos" ]; then
				echo "testcase failed"
				exit
		fi

		if [ -z "$twoTezPos" ]; then
				echo "testcase failed"
				exit
		fi

		if [ -z "$threeTezPos" ]; then
				echo "testcase failed"
				exit
		fi

		if [ $oneTezPos -lt $twoTezPos ]; then
				if [ $twoTezPos -lt $threeTezPos ]; then
						echo "testcase succeeded"
				else
						echo "testcase failed"
				fi
		else
				echo "testcase failed"
		fi
		;;
esac
#rm *.tmp
#rm -rf compiled