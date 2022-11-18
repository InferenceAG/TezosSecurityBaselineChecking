#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	kathmandu | jakarta | ithaca)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract join transferring 0 from deploy running tickets_join_beforeLima.tz --init "None" --burn-cap 0.0815 --force >out.tmp 2>&1
		join=""\"$($TEZOSCLIENT list known contracts |grep join |awk '{ print $2}')\"""
	    $TEZOSCLIENT transfer 0 from deploy to join --entrypoint "default" --arg "(Pair $join \"test\" 1)" >result.tmp 2>&1
		checkResult result.tmp "is invalid for type ticket string."
		;;
	*)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract join transferring 0 from deploy running tickets_join.tz --init "None" --burn-cap 0.1 --force >out.tmp 2>&1
		join=""\"$($TEZOSCLIENT list known contracts |grep join |awk '{ print $2}')\"""
	    $TEZOSCLIENT transfer 0 from deploy to join --entrypoint "default" --arg "(Pair $join \"test\" 1)" >result.tmp 2>&1
		checkResult result.tmp "is invalid for type ticket string."
		;;
esac
rm *.tmp