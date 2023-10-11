#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

# Kernel: https://tezos.gitlab.io/_downloads/1a9fe0df723edf647c4758e2b14b69e7/sr_boot_kernel.sh

case $1 in
	oxford | nairobi)
		echo "executing tests for $1"
		$TEZOSCLIENT originate smart rollup basicKernel from deploy of kind wasm_2_0_0 of type bytes with kernel kernel.hex --burn-cap 999 --force >deploy_rollup.tmp 2>&1
		$TEZOSCLIENT originate contract tezSender transferring 1 from deploy running tezSender.tz --burn-cap 1 --force >deploy_contract.tmp 2>&1
		rollup=""\"$($TEZOSCLIENT list known smart rollups |grep basicKernel |awk '{ print $2}')\"""
		$TEZOSCLIENT transfer 0 from deploy to tezSender --arg "$rollup" >result.tmp 2>&1
		checkResult result.tmp "Transaction amount to a rollup must be zero."
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp