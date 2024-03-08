#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "contract_testing"

case $1 in
	oxford)
		echo "executing tests for $1"
		# Note: The interface "ticket string" does not match the real interface ("bytes") from the deployed kernel. However this does not matter for the sake of this test case.
		$TEZOSCLIENT originate smart rollup basicKernel from deploy of kind wasm_2_0_0 of type "ticket string" with kernel kernel.hex --burn-cap 1 --force >out.tmp 2>&1
		rollup=""\"$($TEZOSCLIENT list known smart rollups |grep basicKernel |awk '{ print $2}')\"""

		$TEZOSCLIENT originate contract contract_testing transferring 0 from deploy running contract.tz --burn-cap 1 --force >out2.tmp 2>&1
		
		$TEZOSCLIENT transfer 0 from deploy to contract_testing --arg "$rollup" >result.tmp 2>&1
		checkResult result.tmp "script reached FAILWITH instruction"
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp
