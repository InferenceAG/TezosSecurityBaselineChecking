#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "join"
removeContract "caller"

case $1 in
	oxford)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract join transferring 0 from deploy running tickets_join.tz --init "Unit" --burn-cap 0.1 --force >out1.tmp 2>&1
		join=""\"$($TEZOSCLIENT list known contracts |grep join |awk '{ print $2}')\"""
		$TEZOSCLIENT originate contract caller transferring 0 from deploy running caller.tz --init "Unit" --burn-cap 0.1 --force >out2.tmp 2>&1
	  	$TEZOSCLIENT transfer 0 from deploy to caller --entrypoint "default" --arg "$join" >result.tmp 2>&1
		checkResult result.tmp "script reached FAILWITH instruction"
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp