#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

# Kernel: https://tezos.gitlab.io/_downloads/1a9fe0df723edf647c4758e2b14b69e7/sr_boot_kernel.sh

case $1 in
	oxford | nairobi)
		echo "executing tests for $1"
		$TEZOSCLIENT originate smart rollup basicKernel from deploy of kind wasm_2_0_0 of type bytes with kernel kernel.hex --burn-cap 999 --force >deploy.tmp 2>&1
		$TEZOSCLIENT transfer 1 from deploy to basicKernel >result.tmp 2>&1
		checkResult result.tmp "  no contract or key named basicKernel"

		rollup=""\"$($TEZOSCLIENT list known smart rollups |grep basicKernel |awk '{ print $2}')\"""
		$TEZOSCLIENT transfer 1 from deploy to $rollup >result2.tmp 2>&1
		checkResult result.tmp "  bad contract notation"

		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp