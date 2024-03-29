#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "long_entrypoint_name"
removeContract "call_contract_with_long_entrypoint_name"

case $1 in
	oxford)
		echo "executing tests for $1"				
		echo "## Sub testcase #1:"
		$TEZOSCLIENT originate contract long_entrypoint_name transferring 0 from deploy running contract_long_entrypoint_name.tz --burn-cap 1 --force >result1.tmp 2>&1

		checkResult result1.tmp "    \"An entrypoint name exceeds the maximum length of 31 characters.\","

		echo "## Sub testcase #2:"
		$TEZOSCLIENT originate contract call_contract_with_long_entrypoint_name transferring 0 from deploy running caller.tz --burn-cap 1 --force >result2.tmp 2>&1

		checkResult result2.tmp "    \"An entrypoint name exceeds the maximum length of 31 characters.\","
		;;

	*)
		echo "not supported $1"
		;;	
	
esac
rm *.tmp
