#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		$SMARTPY compile storeValue.py compiled/ --purge >result.tmp 2>&1
		checkResult result.tmp "Exception: Cannot convert expression to bool. Conditionals are forbidden on contract expressions. Please use ~ or sp.if instead of not or if."

		;;
esac
rm *.tmp
rm -rf compiled