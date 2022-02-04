#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract dup_op transferring 0 from deploy running dup_transfer.tz --init "Unit" --burn-cap 0.1 --force >out.tmp 2>&1
		dupOp=""\"$($TEZOSCLIENT list known contracts |grep dup_op |awk '{ print $2}')\"""
	    $TEZOSCLIENT transfer 1 from deploy to dup_op --entrypoint "default" >result.tmp 2>&1
		checkResult result.tmp "Internal operation replay attempt:"
		;;
esac
rm *.tmp