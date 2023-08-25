#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "ticket_dup"

case $1 in
	oxford)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract ticket_dup transferring 0 from deploy running tickets_list.tz --init 'Unit' --force >result.tmp 2>&1
		checkResult result.tmp "type list (ticket string) cannot be used here because it is not duplicable. Only duplicable types can be used with the DUP instruction and as view inputs and outputs."
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp