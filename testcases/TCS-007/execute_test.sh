#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		echo "executing operator test case 1:"
		$SMARTPY test operator_case1.py out_1 > result.tmp 2>&1
		checkResult result.tmp "SyntaxError: invalid syntax. Maybe you meant '==' or ':=' instead of '='?"

		echo "executing operator test case 2:"
		$SMARTPY test operator_case2.py out_2 > result.tmp 2>&1
		checkResult result.tmp "smartpy-parser: operator_case2.py:15:13-32: error: Not an expression: self.intFunc(x=True)"
		;;
esac
#rm *.tmp
#rm -rf out_1
#rm -rf out_2