#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../../_framework/init.sh"
. "$SCRIPT_DIR/../../_framework/functions.sh"

getTestcaseTitle

removeContract "ticket_dup"

case $1 in
	latest)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract ticket_dup transferring 0 from deploy running tickets_dup_n10.tz --init 'Unit' --force >result.tmp 2>&1
		checkResult result.tmp "type option (ticket string) cannot be used here because it is not duplicable. Only duplicable types can be used with the DUP instruction and as view inputs and outputs."
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp