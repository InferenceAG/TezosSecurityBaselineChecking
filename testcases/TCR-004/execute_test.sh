#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

case $1 in
	oxford)
		echo "executing tests for $1"
		$TEZOSCLIENT originate smart rollup basicKernel from deploy of kind wasm_2_0_0 of type bytes with kernel kernel.hex --burn-cap 999 -–force >out.tmp 2>&1
		 
		$TEZOSCLIENT transfer 0 from deploy to basicKernel --arg "0x00" >result.tmp 2>&1
		checkResult result.tmp "  no contract or key named basicKernel"
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp
