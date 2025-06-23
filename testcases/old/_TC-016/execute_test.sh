#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "storage_contract"
removeContract "implementation_contract"

case $1 in
	oxford)
		echo "executing tests for $1"				
		storage="(Pair 0 {})"
		$TEZOSCLIENT originate contract storage_contract transferring 0 from deploy running storage_contract.tz --init "$storage" --burn-cap 1 --force >deploy1.tmp 2>&1
		storage="0"
		$TEZOSCLIENT originate contract implementation_contract transferring 0 from deploy running implementation_contract.tz --init "$storage" --burn-cap 1 --force >deploy2.tmp 2>&1

		deploy="$($TEZOSCLIENT list known contracts |grep deploy |awk '{ print $2}')"
		arg="(Pair 10 \"$deploy\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'addMul' --arg "$arg" --burn-cap 100 > result1.tmp 2>&1

		# Do not compare with this result, since contract may not be cached.
		implementation_contract="$($TEZOSCLIENT list known contracts |grep implementation_contract |awk '{ print $2}')"
		arg="(Pair 9 \"$implementation_contract\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'call' --arg "$arg" --burn-cap 100 > result2.tmp 2>&1
		
		arg="(Pair 500 \"$deploy\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'addMul' --arg "$arg" --burn-cap 100 > result3.tmp 2>&1

		implementation_contract="$($TEZOSCLIENT list known contracts |grep implementation_contract |awk '{ print $2}')"
		arg="(Pair 509 \"$implementation_contract\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'call' --arg "$arg" --burn-cap 100 > result4.tmp 2>&1

		arg="(Pair 500 \"$deploy\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'addMul' --arg "$arg" --burn-cap 100 >> result3.tmp 2>&1

		arg="(Pair 500 \"$deploy\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'addMul' --arg "$arg" --burn-cap 100 > result3.tmp 2>&1

		arg="(Pair 500 \"$deploy\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'addMul' --arg "$arg" --burn-cap 100 >> result3.tmp 2>&1

		arg="(Pair 500 \"$deploy\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'addMul' --arg "$arg" --burn-cap 100 >> result3.tmp 2>&1

		arg="(Pair 500 \"$deploy\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'addMul' --arg "$arg" --burn-cap 100 >> result3.tmp 2>&1

		arg="(Pair 500 \"$deploy\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'addMul' --arg "$arg" --burn-cap 100 >> result3.tmp 2>&1

		arg="(Pair 500 \"$deploy\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'addMul' --arg "$arg" --burn-cap 100 >> result3.tmp 2>&1

		arg="(Pair 500 \"$deploy\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'addMul' --arg "$arg" --burn-cap 100 >> result3.tmp 2>&1

		arg="(Pair 500 \"$deploy\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'addMul' --arg "$arg" --burn-cap 100 >> result3.tmp 2>&1

		implementation_contract="$($TEZOSCLIENT list known contracts |grep implementation_contract |awk '{ print $2}')"
		arg="(Pair 509 \"$implementation_contract\")"
		$TEZOSCLIENT transfer 0 from deploy to storage_contract --entrypoint 'call' --arg "$arg" --burn-cap 100 > result5.tmp 2>&1

		echo "failed - due TODOs"
		# TODO: Compare gas cost from result4 with result5
		;;

	*)
		echo "not supported $1"
		;;	
	
esac
#rm *.tmp