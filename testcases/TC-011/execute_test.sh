#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		admin="$($TEZOSCLIENT list known addresses |grep admin |awk '{ print $2}')"
		
		sed "s/destinationAddress/$admin/g" ordering_temp.tz > ordering.tz
		
		$TEZOSCLIENT originate contract ordering_basic transferring 6 from deploy running ordering.tz --burn-cap 0.2 --force >out.tmp 2>&1
		

		$TEZOSCLIENT transfer 0 from admin to ordering_basic --entrypoint 'default' >result.tmp 2>&1

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
