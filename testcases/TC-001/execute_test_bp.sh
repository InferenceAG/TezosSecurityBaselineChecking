#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		# KT1PWx2mnDueood7fEmfbBDKx1D9BAnnXitn is the tzBTC contract on mainnet
		$TEZOSCLIENT transfer 1 from deploy to KT1PWx2mnDueood7fEmfbBDKx1D9BAnnXitn >result.tmp 2>&1 
		checkResult result.tmp "Contract KT1PWx2mnDueood7fEmfbBDKx1D9BAnnXitn does not exist"
		;;
esac
rm *.tmp
