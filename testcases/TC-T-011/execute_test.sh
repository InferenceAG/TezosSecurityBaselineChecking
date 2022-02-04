#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		$LIGO compile contract caller.ligo > caller.tz
		$TEZOSCLIENT originate contract caller transferring 0 from deploy running caller.tz --init 'Unit' --burn-cap 0.108  --force >out1.tmp 2>&1
		caller=""\"$($TEZOSCLIENT list known contracts |grep caller |awk '{ print $2}')\"""
		$TEZOSCLIENT originate contract getter transferring 0 from deploy running getter.tz --init 'Unit' --burn-cap 0.1005 --force >out2.tmp 2>&1
		getter=""\"$($TEZOSCLIENT list known contracts |grep getter |awk '{ print $2}')\"""
		$TEZOSCLIENT transfer 0 from deploy to caller --entrypoint "init" --arg "Pair $getter $caller" >result.tmp 2>&1
		checkResult result.tmp "script reached FAILWITH instruction"
		;;
esac
rm *.tmp