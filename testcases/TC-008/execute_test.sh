#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract TezTransferA transferring 0.000010 from deploy running TezTransfer.tz --init "Pair 0 0" --burn-cap 0.2 --force >outA.tmp 2>&1
		$TEZOSCLIENT originate contract TezTransferB transferring 0 from deploy running TezTransfer.tz --init "Pair 0 0" --burn-cap 0.2 --force >outB.tmp 2>&1
		TezTransferB=""\"$($TEZOSCLIENT list known contracts |grep TezTransferB|awk '{ print $2}')\"""
	    $TEZOSCLIENT transfer 0 from deploy to TezTransferA --entrypoint "default" --arg "Some $TezTransferB" >result.tmp 2>&1
		checkResult result.tmp "        Updated storage: (Pair 5 5)"
		;;
esac
rm *.tmp