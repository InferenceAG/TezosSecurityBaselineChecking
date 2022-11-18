#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	kathmandu | jakarta | ithaca)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract join transferring 0 from deploy running tickets_join_beforeLima.tz --init "Unit" --burn-cap 0.1 --force >out.tmp 2>&1
	  	$TEZOSCLIENT transfer 0 from deploy to join --entrypoint "default" --arg "Unit" >result.tmp 2>&1
		checkResult result.tmp "script reached FAILWITH instruction"
		;;
	*)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract join transferring 0 from deploy running tickets_join.tz --init "Unit" --burn-cap 0.2 --force >out.tmp 2>&1
	  	$TEZOSCLIENT transfer 0 from deploy to join --entrypoint "default" --arg "Unit" >result.tmp 2>&1
		checkResult result.tmp "script reached FAILWITH instruction"
		;;
esac
rm *.tmp