#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract ticket_dup transferring 0 from deploy running tickets_list.tz --init 'Unit' --force >result.tmp 2>&1
		checkResult result.tmp "type list (ticket string) cannot be used here because it is not duplicable. Only duplicable types can be used with the DUP instruction and as view inputs and outputs."
		;;
esac
rm *.tmp