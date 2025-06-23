#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "voting_power"

# key_has for tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs is 0x009c3c5a33f9350cfcbe46ab07ccaecc6792365101
# However, octez-client expects key_hash not in hex, but in the tz form
case $1 in
oxford)
	echo "executing tests for $1"

	echo "## Sub testcase #1:"
	$TEZOSCLIENT originate contract voting_power transferring 0 from deploy running voting_power.tz --init 'Pair 0 0' --burn-cap 1 --force >result1a.tmp 2>&1
	checkResult result1a.tmp "Contract memorized as voting_power."

	$TEZOSCLIENT transfer 0 from admin to voting_power --arg '"tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs"' --entrypoint "default" --burn-cap 1 >result1b.tmp 2>&1
	checkResult result1b.tmp "The operation has only been included 0 blocks ago."
	result=$(cat result1b.tmp | grep "Updated storage:" | awk '{print $5}' | sed 's/)//g')
	if [ "$result" -gt 10000000 ]; then
		echo "testcase succeeded"
	else 
		echo "testcase failed"
	fi

	# Consensus key of tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs
	$TEZOSCLIENT transfer 0 from admin to voting_power --arg '"tz4RwHj1g2gEYhsrXvcKgidXCNCFPuGPY41v"' --entrypoint "default" --burn-cap 1 >result1c.tmp 2>&1
	checkResult result1c.tmp "The operation has only been included 0 blocks ago."
	result=$(cat result1c.tmp | grep "Updated storage:" | grep " 0)")
	if [ -z "$result" ]; then
		echo "testcase failed"
	else 
		echo "testcase succeeded"
	fi

	# Companion key of tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs
	$TEZOSCLIENT transfer 0 from admin to voting_power --arg '"tz4XbGtqxNZDq6CJNVbxktoqSTu9Db6aXQHL"' --entrypoint "default" --burn-cap 1 >result1d.tmp 2>&1
	checkResult result1d.tmp "The operation has only been included 0 blocks ago."
	result=$(cat result1d.tmp | grep "Updated storage:" | grep " 0)")
	if [ -z "$result" ]; then
		echo "testcase failed"
	else 
		echo "testcase succeeded"
	fi

	## baker with tz4 3-of-3 manager key tz4EMqJE7UMrniQ3zfRs7zNEV27VMbHkjJjF
	#$TEZOSCLIENT transfer 0 from admin to voting_power --arg '"tz4EMqJE7UMrniQ3zfRs7zNEV27VMbHkjJjF"' --entrypoint "default" --burn-cap 1 >result1e.tmp 2>&1
	#checkResult result1e.tmp "The operation has only been included 0 blocks ago."
	#result=$(cat result1e.tmp | grep "Updated storage:" | awk '{print $5}' | sed 's/)//g')
	#if [ "$result" -gt 1000000 ]; then
	#	echo "testcase succeeded"
	#else 
	#	echo "testcase failed"
	#fi
	;;
*)
	echo "not supported $1"
	;;
esac
#rm *.tmp
