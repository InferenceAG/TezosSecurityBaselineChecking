#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../../_framework/init.sh"
. "$SCRIPT_DIR/../../_framework/functions.sh"

getTestcaseTitle

case $1 in
	*)
		echo "executing tests for $1"
		# KT1PWx2mnDueood7fEmfbBDKx1D9BAnnXitn is the tzBTC contract on mainnet
		$TEZOSCLIENT transfer 1 from deploy to KT1PWx2mnDueood7fEmfbBDKx1D9BAnnXitn >result.tmp 2>&1 
		checkResult result.tmp "Contract KT1PWx2mnDueood7fEmfbBDKx1D9BAnnXitn does not exist"
		;;
esac
rm *.tmp
