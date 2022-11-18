#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	kathmandu | jakarta | ithaca)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract map_dup transferring 0 from deploy running tickets_dup_map_beforeLima.tz --init "Unit" --burn-cap 0.1 --force  >result.tmp 2>&1
		
		checkResult result.tmp "type map nat (ticket string) cannot be used here because it is not duplicable. Only duplicable types can be used with the DUP instruction and as view inputs and outputs."
		;;
	*)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract map_dup transferring 0 from deploy running tickets_dup_map.tz --init "Unit" --burn-cap 0.1 --force  >result.tmp 2>&1
		
		checkResult result.tmp "type map nat (ticket string) cannot be used here because it is not duplicable. Only duplicable types can be used with the DUP instruction and as view inputs and outputs."
		;;
esac
rm *.tmp
