#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"	

		echo "## Sub testcase #1:"
		$TEZOSCLIENT originate contract push_contract_type transferring 0 from deploy running caller_PUSH_contract.tz --burn-cap 1 --force >result1.tmp 2>&1

		checkResult result1.tmp "Contract memorized as push_contract_type."

		echo "## Sub testcase #2:"
		$TEZOSCLIENT originate contract right_contract_type transferring 0 from deploy running caller_RIGHT_contract.tz --burn-cap 1 --force >result2.tmp 2>&1

		checkResult result2.tmp "Contract memorized as right_contract_type."
esac
rm *.tmp
rm -rf compiled
