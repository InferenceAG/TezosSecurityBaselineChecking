#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

case $1 in
	oxford)
		echo "executing tests for $1"
		$SMARTPY test storeValue.py compiled/ >result.tmp 2>&1
		checkResult result.tmp "Exception: Cannot convert expression to bool. Conditionals are forbidden on contract expressions. Please use ~ or sp.if instead of not or if."

		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp
rm -rf compiled
