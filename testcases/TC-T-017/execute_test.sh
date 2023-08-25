#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "rogue"

case $1 in
	oxford)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract rogue transferring 0 from deploy running tickets_rogue.tz --init "Some (Pair \"KT1Pmz71yHTCmDHiJ9quFpb9cKANeeb2evV2\" \"test\" 2)" --burn-cap 0.0815 >result.tmp 2>&1
		checkResult result.tmp "is not an expression of type ticket string"
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp