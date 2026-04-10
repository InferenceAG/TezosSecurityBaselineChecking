#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../../_framework/init.sh"
. "$SCRIPT_DIR/../../_framework/functions.sh"

getTestcaseTitle

removeContract "getter"

case $1 in
	latest)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract getter transferring 0 from deploy running tickets_lambda.tz --init 'Unit' --force >result.tmp 2>&1

		#checkResult result.tmp "Type pair string string nat is not compatible with type ticket string."
  		checkResult result.tmp "At line 6 characters 11 to 63, Type pair string string nat"
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp
