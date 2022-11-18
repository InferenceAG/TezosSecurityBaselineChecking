#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	kathmandu | jakarta | ithaca)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract ticket_dup transferring 0 from deploy running tickets_view_beforeLima.tz --init 'None' --force >result.tmp 2>&1
		checkResult result.tmp "At (unshown) location 25, Ticket in unauthorized position (type error)."
		;;
	*)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract ticket_dup transferring 0 from deploy running tickets_view.tz --init 'None' --force >result.tmp 2>&1
		checkResult result.tmp "At (unshown) location 24, Ticket in unauthorized position (type error)."
		;;
esac
rm *.tmp