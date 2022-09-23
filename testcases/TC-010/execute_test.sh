#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"

		# addition contract
		$LIGO compile contract calculations.ligo > calculations.tz.tmp
		$TEZOSCLIENT originate contract calculations transferring 0 from deploy running calculations.tz.tmp --init "0" --burn-cap 0.9 --force >out1.tmp 2>&1
		calculationAddress=$($TEZOSCLIENT list known contracts |grep calculations | awk '{print $2}')

		sed "s/mydestination/$calculationAddress/g" transaction.json > transaction.tmp.json 
		$TEZOSCLIENT multiple transfers from deploy using transaction.tmp.json > result.tmp 2>&1
		
		# TODO: Improve. Check order, etc.
		#checkResult result.tmp "      This transaction was BACKTRACKED, its expected effects (as follow) were NOT applied."
                checkResult result.tmp "      This transaction was BACKTRACKED, its expected effects were NOT applied."

		checkResult result.tmp "      This operation FAILED."	

		#checkResult result.tmp "      This operation was skipped"
                checkResult result.tmp "      This operation was skipped."
		;;
esac
#rm *.tmp
