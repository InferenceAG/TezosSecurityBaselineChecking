#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "join"

case $1 in
	oxford)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract join transferring 0 from deploy running tickets_join.tz --init "None" --burn-cap 1 --force >out.tmp 2>&1
		join=""\"$($TEZOSCLIENT list known contracts |grep join |awk '{ print $2}')\"""
	    $TEZOSCLIENT transfer 0 from deploy to join --entrypoint "default" --arg "Some (Pair $join \"test\" 1)" >result.tmp 2>&1
		checkResult result.tmp "is invalid for type ticket string."
		;;

	*)
		echo "not supported $1"
		;;	
esac
#rm *.tmp