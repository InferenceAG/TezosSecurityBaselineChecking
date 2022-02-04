#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract rogue transferring 0 from deploy running tickets_rogue.tz --init "Some (Pair \"KT1Pmz71yHTCmDHiJ9quFpb9cKANeeb2evV2\" \"test\" 2)" --burn-cap 0.0815 >result.tmp 2>&1
		checkResult result.tmp "is not an expression of type ticket string"
		;;
esac
rm *.tmp