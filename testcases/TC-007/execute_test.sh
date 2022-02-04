#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract zeroTezTransfer transferring 0 from deploy running zeroTezTransfer.tz --init "Unit" --burn-cap 0.1 --force >out.tmp 2>&1
		deploy=""\"$($TEZOSCLIENT list known addresses |grep deploy|awk '{ print $2}')\"""
		deployOnlyString="$($TEZOSCLIENT list known addresses |grep deploy|awk '{ print $2}')"
	    $TEZOSCLIENT transfer 0 from deploy to zeroTezTransfer --entrypoint "default" --arg "$deploy" >result.tmp 2>&1
		checkResult result.tmp "Transactions of 0ꜩ towards a contract without code are forbidden ($deployOnlyString)."
		;;
esac
rm *.tmp