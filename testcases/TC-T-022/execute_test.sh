#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "join"
removeContract "dup_op"

case $1 in
	oxford)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract join transferring 0 from deploy running tickets_join.tz --init "None" --burn-cap 0.1 --force >out1.tmp 2>&1
		join=""\"$($TEZOSCLIENT list known contracts |grep join |awk '{ print $2}')\"""
		$TEZOSCLIENT originate contract dup_op transferring 0 from deploy running tickets_operation.tz --init "Unit" --burn-cap 0.1 --force >out2.tmp 2>&1
	    $TEZOSCLIENT transfer 0 from deploy to dup_op --entrypoint "default" --arg "$join" --burn-cap 0.1 >result.tmp 2>&1
		checkResult result.tmp "Internal operation replay attempt:"
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp
