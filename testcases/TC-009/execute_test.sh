#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "addition"

case $1 in
	oxford)
		echo "executing tests for $1"

		# addition contract
		$TEZOSCLIENT originate contract addition transferring 0 from deploy running addition.tz --init "0" --burn-cap 0.9 --force >out1.tmp 2>&1

		# Case 1: This works
		# Calls entrypoint: (pair %add (nat %valueA) (nat %valueB))
		# Calling Michelson code: CONTRACT %add (pair (nat %valueA) (nat %valueB)) ;
		echo "testcase 1"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'call' --arg "(Pair (Left (Left Unit)) (Pair 1 2))" > result1.tmp 2>&1
		checkResult result1.tmp "The operation has only been included 0 blocks ago."

		# Case 2: This works
		# Calls entrypoint: (pair %addNoAnnot nat nat))
		# Calling Michelson code: CONTRACT %addNoAnnot (pair (nat %valueA) (nat %valueB)) ;
	 	echo "testcase 2"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'call' --arg "(Pair (Left (Right Unit)) (Pair 1 2))" > result2.tmp 2>&1
		checkResult result2.tmp "The operation has only been included 0 blocks ago."
		
		# Case 3: This now works with Jakarta:
		# Calls entrypoint: (pair %addWrongAnnot (nat %a) (nat %b))
		# Calling Michelson code: CONTRACT %addWrongAnnot (pair (nat %valueA) (nat %valueB)) ;
		echo "testcase 3"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'call' --arg "(Pair (Right Unit) (Pair 1 2))" > result3.tmp 2>&1
		checkResult result3.tmp "The operation has only been included 0 blocks ago."

		# Case 4: This works
		# Calls entrypoint: (pair %add (nat %valueA) (nat %valueB))
		# Calling Michelson code: CONTRACT %add (pair nat nat) ;
		echo "testcase 4"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callNoAnnot' --arg "(Pair (Left (Left Unit)) (Pair 1 2))" > result4.tmp 2>&1
		checkResult result4.tmp "The operation has only been included 0 blocks ago."

		# Case 5: This works
		# Calls entrypoint: CONTRACT %addNoAnnot (pair nat nat) ;
		# Calling Michelson code: CONTRACT %addNoAnnot (pair (nat %valueA) (nat %valueB)) ;
		echo "testcase 5"
	 	$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callNoAnnot' --arg "(Pair (Left (Right Unit)) (Pair 1 2))" > result5.tmp 2>&1
		checkResult result5.tmp "The operation has only been included 0 blocks ago."

		# Case 6: This works
		# Calls entrypoint: CONTRACT %addWrongAnnot (pair nat nat) ;
		# Calling Michelson code: CONTRACT %addWrongAnnot (pair (nat %valueA) (nat %valueB)) ;
		echo "testcase 6"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callNoAnnot' --arg "(Pair (Right Unit) (Pair 1 2))" > result6.tmp 2>&1
		checkResult result6.tmp "The operation has only been included 0 blocks ago."
		
		# Case 7: This now works with Jakarta:
		# Calls entrypoint: (pair %add (nat %valueA) (nat %valueB))
		# Calling Michelson code: CONTRACT %add (pair (nat %a) (nat %b)) ;
		echo "testcase 7"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callWrongAnnot' --arg "(Pair (Left (Left Unit)) (Pair 1 2))" > result7.tmp 2>&1
		checkResult result6.tmp "The operation has only been included 0 blocks ago."

		# Case 8: This works
		# Calls entrypoint: (pair %addNoAnnot nat nat))
		# Calling Michelson code: CONTRACT %add (pair (nat %a) (nat %b))
		echo "testcase 8" 
	 	$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callWrongAnnot' --arg "(Pair (Left (Right Unit)) (Pair 1 2))" > result8.tmp 2>&1
		checkResult result8.tmp "The operation has only been included 0 blocks ago." 

		# Case 9: This works
		# Calls entrypoint: (pair %addWrongAnnot (nat %a) (nat %b))
		# Calling Michelson code: CCONTRACT %add (pair (nat %a) (nat %b)) 
		echo "testcase 9"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callWrongAnnot' --arg "(Pair (Right Unit) (Pair 1 2))" > result9.tmp 2>&1
		checkResult result9.tmp "The operation has only been included 0 blocks ago."
		;;

	*)
		echo "not supported $1"
		;;	

esac
rm *.tmp
