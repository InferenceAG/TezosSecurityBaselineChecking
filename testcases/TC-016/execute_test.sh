#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "is_implicit_account_cmp"
removeContract "implicit_account"
removeContract "is_implicit_account"


# key_hash for tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs is 0x009c3c5a33f9350cfcbe46ab07ccaecc6792365101
# However, octez-client expects key_hash not in hex, but in the tz form
case $1 in
	oxford)
		echo "executing tests for $1"	

		echo "## Sub testcase #1:"
		$TEZOSCLIENT originate contract is_implicit_account_cmp transferring 0 from deploy running is_implicit_account_cmp.tz --burn-cap 1 --force >result1a.tmp 2>&1
		checkResult result1a.tmp "Contract memorized as is_implicit_account_cmp."

		$TEZOSCLIENT transfer 0 from admin to is_implicit_account_cmp --arg '(Pair "tz1Yh4dvqiLQtGzNr8HAxoCX2SZkgAhVCRwu" "tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs")' --entrypoint "default" >result1b.tmp 2>&1
		checkResult result1b.tmp "script reached FAILWITH instruction"

		$TEZOSCLIENT transfer 0 from admin to is_implicit_account_cmp --arg '(Pair "tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs" "tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs")' --entrypoint "default" >result1c.tmp 2>&1
		checkResult result1c.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to is_implicit_account_cmp --arg '(Pair "tz4VtrRfgNiav8QWeGfzXY9mwU3tLsACJxWU" "tz4VtrRfgNiav8QWeGfzXY9mwU3tLsACJxWU")' --entrypoint "default" >result1d.tmp 2>&1
		checkResult result1d.tmp "The operation has only been included 0 blocks ago."

		echo "## Sub testcase #2:"
		$TEZOSCLIENT originate contract implicit_account transferring 0 from deploy running implicit_account_cmp.tz --burn-cap 1 --force >result2a.tmp 2>&1
		checkResult result2a.tmp "Contract memorized as implicit_account."

		$TEZOSCLIENT transfer 0 from admin to implicit_account --arg '(Pair "tz1Yh4dvqiLQtGzNr8HAxoCX2SZkgAhVCRwu" "tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs")' --entrypoint "default" >result2b.tmp 2>&1
		checkResult result2b.tmp "script reached FAILWITH instruction"

		$TEZOSCLIENT transfer 0 from admin to implicit_account --arg '(Pair "tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs" "tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs")' --entrypoint "default" >result2c.tmp 2>&1
		checkResult result2c.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to implicit_account --arg '(Pair "tz4VtrRfgNiav8QWeGfzXY9mwU3tLsACJxWU" "tz4VtrRfgNiav8QWeGfzXY9mwU3tLsACJxWU")' --entrypoint "default" >result2d.tmp 2>&1
		checkResult result2d.tmp "The operation has only been included 0 blocks ago."

		echo "## Sub testcase #3:"
		$TEZOSCLIENT originate contract is_implicit_account transferring 0 from deploy running is_implicit_account.tz --burn-cap 1 --force >result3a.tmp 2>&1
		checkResult result3a.tmp "Contract memorized as is_implicit_account."

		# check whether a smart contract address returns none and thus failing.
		$TEZOSCLIENT transfer 0 from admin to is_implicit_account --arg '"KT1PWx2mnDueood7fEmfbBDKx1D9BAnnXitn"' --entrypoint "default" >result3b.tmp 2>&1
		checkResult result3b.tmp "script reached FAILWITH instruction"

		# check whether a smart rollup address returns none and thus failing.
		$TEZOSCLIENT transfer 0 from admin to is_implicit_account --arg '"sr1Ghq66tYK9y3r8CC1Tf8i8m5nxh8nTvZEf"' --entrypoint "default" >result3c.tmp 2>&1
		checkResult result3c.tmp "script reached FAILWITH instruction"

		# check whether a implicit address returns some and thus not failing.
		$TEZOSCLIENT transfer 0 from admin to is_implicit_account --arg '"tz1Yh4dvqiLQtGzNr8HAxoCX2SZkgAhVCRwu"' --entrypoint "default" >result3d.tmp 2>&1
		checkResult result3d.tmp "The operation has only been included 0 blocks ago."
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp
