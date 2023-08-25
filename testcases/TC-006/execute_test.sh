#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "dup_op"

case $1 in
	oxford)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract dup_op transferring 0 from deploy running dup_transfer.tz --init "Unit" --burn-cap 0.1 --force >out.tmp 2>&1
		dupOp=""\"$($TEZOSCLIENT list known contracts |grep dup_op |awk '{ print $2}')\"""
	    $TEZOSCLIENT transfer 1 from deploy to dup_op --entrypoint "default" >result.tmp 2>&1
		checkResult result.tmp "Internal operation replay attempt:"
		;;
	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp