#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "address_index"
removeContract "address_index_2"
removeContract "view_index_address"

# See information regarding "compare" of addresses: https://tezos.gitlab.io/michelson-reference/#instr-COMPARE

case $1 in
	latest)
		echo "executing tests for $1"	

		# Check whether INDEX_ADDRESS and GET_ADDRESS_INDEX work as expected.
		echo "## Sub testcase #1:"
		$TEZOSCLIENT originate contract address_index transferring 0 from deploy running address_index.tz --init '{}' --burn-cap 1 --force >result1a.tmp 2>&1
		checkResult result1a.tmp "Contract memorized as address_index."
	
		$TEZOSCLIENT transfer 0 from admin to address_index --arg '"tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU"' --entrypoint "default" --burn-cap 1 >result1b.tmp 2>&1
		checkResult result1b.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to address_index --arg '"tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs"' --entrypoint "default" --burn-cap 1 >result1c.tmp 2>&1
		checkResult result1c.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to address_index --arg '"tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU"' --entrypoint "default" --burn-cap 1 >result1d.tmp 2>&1
		checkResult result1d.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to address_index --arg '"tz28KEfLTo3wg2wGyJZMjC1MaDA1q68s6tz5"' --entrypoint "default" --burn-cap 1 >result1e.tmp 2>&1
		checkResult result1e.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to address_index --arg '"tz3LL3cfMfBV4fPaPZdcj9TjPa3XbvLiXw9V"' --entrypoint "default" --burn-cap 1 >result1f.tmp 2>&1
		checkResult result1f.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to address_index --arg '"tz491FasxEbqzR2SfjgTPnRyw9JY7og2HZUA"' --entrypoint "default" --burn-cap 1 >result1g.tmp 2>&1
		checkResult result1g.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to address_index --arg '"KT18amZmM5W7qDWVt2pH6uj7sCEd3kbzLrHT"' --entrypoint "default" --burn-cap 1 >result1h.tmp 2>&1
		checkResult result1h.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to address_index --arg '"sr163Lv22CdE8QagCwf48PWDTquk6isQwv57"' --entrypoint "default" --burn-cap 1 >result1i.tmp 2>&1
		checkResult result1i.tmp "The operation has only been included 0 blocks ago."

		index_1=$($TEZOSCLIENT run view getIndex on contract address_index with input '"tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU"' | awk '{ print $2 }' | sed 's/)//g')
		

		# Check whether INDEX_ADDRESS can not be in a view.
		echo "## Sub testcase #2:"
		$TEZOSCLIENT originate contract view_index_address transferring 0 from deploy running view_index_address.tz --init '{}' --burn-cap 1 --force >result2a.tmp 2>&1
		checkResult result2a.tmp "The INDEX_ADDRESS instruction cannot appear in a view."


		# Run again to check whether INDEX_ADDRESS and GET_ADDRESS_INDEX are global and not per contract.
		echo "## Sub testcase #3:"
		$TEZOSCLIENT originate contract address_index_2 transferring 0 from deploy running address_index.tz --init '{}' --burn-cap 1 --force >result3a.tmp 2>&1
		checkResult result3a.tmp "Contract memorized as address_index_2."
	
		$TEZOSCLIENT transfer 0 from admin to address_index_2 --arg '"tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU"' --entrypoint "default" --burn-cap 1 >result3b.tmp 2>&1
		checkResult result3b.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to address_index_2 --arg '"tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs"' --entrypoint "default" --burn-cap 1 >result3c.tmp 2>&1
		checkResult result3c.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to address_index_2 --arg '"tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU"' --entrypoint "default" --burn-cap 1 >result3d.tmp 2>&1
		checkResult result3d.tmp "The operation has only been included 0 blocks ago."

		index_2=$($TEZOSCLIENT run view getIndex on contract address_index with input '"tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU"' | awk '{ print $2 }' | sed 's/)//g')
		if [ "$index_1" != "$index_2" ] ; then
			echo "testcase failed"
		else
			echo "testcase succeeded"
		fi

		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp
