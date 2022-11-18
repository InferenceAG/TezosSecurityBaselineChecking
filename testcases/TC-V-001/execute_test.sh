#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	ithaca | jakarta | *)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract rogue transferring 0 from deploy running rogue_add.tz --init 'Unit' --force >result.tmp 2>&1
		checkResult result.tmp "At line 4 characters 46 to 49, wrong stack type for instruction ADD: []."
		;;
	kathmandu)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract rogue transferring 0 from deploy running rogue_add.tz --init 'Unit' --force >result.tmp 2>&1
		checkResult result.tmp "At line 4 characters 46 to 49, wrong stack type for instruction ADD: [ nat ]."
		;;
esac
rm *.tmp