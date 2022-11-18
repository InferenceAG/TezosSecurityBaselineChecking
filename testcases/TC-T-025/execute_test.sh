#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract zeroticket transferring 0 from deploy running tickets_zero_amount.tz --init "Unit" --burn-cap 0.1 --force  >out.tmp 2>&1
		
		$TEZOSCLIENT transfer 0 from deploy to zeroticket --entrypoint "default" --arg "Unit" >result.tmp 2>&1
		checkResult result.tmp "The operation has only been included 0 blocks ago."
		;;

esac
#rm *.tmp