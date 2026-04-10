#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../../_framework/init.sh"
. "$SCRIPT_DIR/../../_framework/functions.sh"

getTestcaseTitle

removeContract "ticket_dup"

case $1 in
	latest)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract ticket_dup transferring 0 from deploy running tickets_pack_pair.tz --init 'Unit' --force >result.tmp 2>&1
		checkResult result.tmp "Ticket in unauthorized position (type error)."
		;;
	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp