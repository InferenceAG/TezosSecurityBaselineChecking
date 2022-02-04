#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract ticket_dup transferring 0 from deploy running tickets_pack_pair.tz --init 'Unit' --force >result.tmp 2>&1
		checkResult result.tmp "Ticket in unauthorized position (type error)."
		;;
esac
rm *.tmp