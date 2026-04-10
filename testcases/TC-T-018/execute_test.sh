#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../../_framework/init.sh"
. "$SCRIPT_DIR/../../_framework/functions.sh"

getTestcaseTitle

removeContract "join"

case $1 in
	latest)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract join transferring 0 from deploy running tickets_join.tz --init "None" --burn-cap 0.1 --force >out.tmp 2>&1
		join=""\"$($TEZOSCLIENT list known contracts |grep join |awk '{ print $2}')\"""
	    $TEZOSCLIENT transfer 0 from deploy to join --entrypoint "default" --arg "(Pair $join \"test\" 1)" >result.tmp 2>&1
		checkResult result.tmp "is invalid for type ticket string."
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp