#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract getter transferring 0 from deploy running tickets_lambda.tz --init 'Unit' --force >result.tmp 2>&1
		checkResult result.tmp "Type pair address string nat is not compatible with type ticket string."
		;;
esac
rm *.tmp