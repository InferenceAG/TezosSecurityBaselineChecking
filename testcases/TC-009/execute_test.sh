#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

head -n 1 readme.md

case $1 in
	*)
		echo "executing tests for $1"

		# addition contract
		$LIGO compile contract addition.ligo > addition.tz.tmp
		$TEZOSCLIENT originate contract addition transferring 0 from deploy running addition.tz.tmp --init "0" --burn-cap 0.9 --force >out1.tmp 2>&1

		# Case 1: This works
		# Calls entrypoint: (pair %add (nat %valueA) (nat %valueB))
		# Calling Michelson code: CONTRACT %add (pair (nat %valueA) (nat %valueB)) ;
		echo "testcase 1"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'call' --arg "(Pair \"Add\" (Pair 1 2))" > result1.tmp 2>&1
		checkResult result1.tmp "The operation has only been included 0 blocks ago."

		# Case 2: This works
		# Calls entrypoint: (pair %addNoAnnot nat nat))
		# Calling Michelson code: CONTRACT %addNoAnnot (pair (nat %valueA) (nat %valueB)) ;
	 	echo "testcase 2"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'call' --arg "(Pair \"AddNoAnnot\" (Pair 1 2))" > result2.tmp 2>&1
		checkResult result2.tmp "The operation has only been included 0 blocks ago."
		
		# Case 3: This now works with Jakarta:
		# Calls entrypoint: (pair %addWrongAnnot (nat %a) (nat %b))
		# Calling Michelson code: CONTRACT %addWrongAnnot (pair (nat %valueA) (nat %valueB)) ;
		echo "testcase 3"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'call' --arg "(Pair \"AddWrongAnnot\" (Pair 1 2))" > result3.tmp 2>&1
		checkResult result3.tmp "The operation has only been included 0 blocks ago."

		# Case 4: This works
		# Calls entrypoint: (pair %add (nat %valueA) (nat %valueB))
		# Calling Michelson code: CONTRACT %add (pair nat nat) ;
		echo "testcase 4"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callNoAnnot' --arg "(Pair \"Add\" (Pair 1 2))" > result4.tmp 2>&1
		checkResult result4.tmp "The operation has only been included 0 blocks ago."

		# Case 5: This works
		# Calls entrypoint: CONTRACT %addNoAnnot (pair nat nat) ;
		# Calling Michelson code: CONTRACT %addNoAnnot (pair (nat %valueA) (nat %valueB)) ;
		echo "testcase 5"
	 	$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callNoAnnot' --arg "(Pair \"AddNoAnnot\" (Pair 1 2))" > result5.tmp 2>&1
		checkResult result5.tmp "The operation has only been included 0 blocks ago."

		# Case 6: This works
		# Calls entrypoint: CONTRACT %addWrongAnnot (pair nat nat) ;
		# Calling Michelson code: CONTRACT %addWrongAnnot (pair (nat %valueA) (nat %valueB)) ;
		echo "testcase 6"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callNoAnnot' --arg "(Pair \"AddWrongAnnot\" (Pair 1 2))" > result6.tmp 2>&1
		checkResult result6.tmp "The operation has only been included 0 blocks ago."
		
		# Case 7: This now works with Jakarta:
		# Calls entrypoint: (pair %add (nat %valueA) (nat %valueB))
		# Calling Michelson code: CONTRACT %add (pair (nat %a) (nat %b)) ;
		echo "testcase 7"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callWrongAnnot' --arg "(Pair \"Add\" (Pair 1 2))" > result7.tmp 2>&1
		checkResult result6.tmp "The operation has only been included 0 blocks ago."

		# Case 8: This works
		# Calls entrypoint: (pair %addNoAnnot nat nat))
		# Calling Michelson code: CONTRACT %add (pair (nat %a) (nat %b))
		echo "testcase 8" 
	 	$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callWrongAnnot' --arg "(Pair \"AddNoAnnot\" (Pair 1 2))" > result8.tmp 2>&1
		checkResult result8.tmp "The operation has only been included 0 blocks ago." 

		# Case 9: This works
		# Calls entrypoint: (pair %addWrongAnnot (nat %a) (nat %b))
		# Calling Michelson code: CCONTRACT %add (pair (nat %a) (nat %b)) 
		echo "testcase 9"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callWrongAnnot' --arg "(Pair \"AddWrongAnnot\" (Pair 1 2))" > result9.tmp 2>&1
		checkResult result9.tmp "The operation has only been included 0 blocks ago."

		;;
	old)
		echo "executing tests for $1"

		# addition contract
		$LIGO compile contract addition.ligo > addition.tz.tmp
		$TEZOSCLIENT originate contract addition transferring 0 from deploy running addition.tz.tmp --init "0" --burn-cap 0.9 --force >out1.tmp 2>&1

		# Case 1: This works
		# Calls entrypoint: (pair %add (nat %valueA) (nat %valueB))
		# Calling Michelson code: CONTRACT %add (pair (nat %valueA) (nat %valueB)) ;
		echo "testcase 1"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'call' --arg "(Pair \"Add\" (Pair 1 2))" > result1.tmp 2>&1
		checkResult result1.tmp "The operation has only been included 0 blocks ago."

		# Case 2: This works
		# Calls entrypoint: (pair %addNoAnnot nat nat))
		# Calling Michelson code: CONTRACT %addNoAnnot (pair (nat %valueA) (nat %valueB)) ;
	 	echo "testcase 2"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'call' --arg "(Pair \"AddNoAnnot\" (Pair 1 2))" > result2.tmp 2>&1
		checkResult result2.tmp "The operation has only been included 0 blocks ago."
		
		# Case 3: This does not work, due to not matching field annotations:
		# Calls entrypoint: (pair %addWrongAnnot (nat %a) (nat %b))
		# Calling Michelson code: CONTRACT %addWrongAnnot (pair (nat %valueA) (nat %valueB)) ;
		echo "testcase 3"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'call' --arg "(Pair \"AddWrongAnnot\" (Pair 1 2))" > result3.tmp 2>&1
		checkResult result3.tmp "At line 53 characters 57 to 65,"

		# Case 4: This works
		# Calls entrypoint: (pair %add (nat %valueA) (nat %valueB))
		# Calling Michelson code: CONTRACT %add (pair nat nat) ;
		echo "testcase 4"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callNoAnnot' --arg "(Pair \"Add\" (Pair 1 2))" > result4.tmp 2>&1
		checkResult result4.tmp "The operation has only been included 0 blocks ago."

		# Case 5: This works
		# Calls entrypoint: CONTRACT %addNoAnnot (pair nat nat) ;
		# Calling Michelson code: CONTRACT %addNoAnnot (pair (nat %valueA) (nat %valueB)) ;
		echo "testcase 5"
	 	$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callNoAnnot' --arg "(Pair \"AddNoAnnot\" (Pair 1 2))" > result5.tmp 2>&1
		checkResult result5.tmp "The operation has only been included 0 blocks ago."

		# Case 6: This works
		# Calls entrypoint: CONTRACT %addWrongAnnot (pair nat nat) ;
		# Calling Michelson code: CONTRACT %addWrongAnnot (pair (nat %valueA) (nat %valueB)) ;
		echo "testcase 6"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callNoAnnot' --arg "(Pair \"AddWrongAnnot\" (Pair 1 2))" > result6.tmp 2>&1
		checkResult result6.tmp "The operation has only been included 0 blocks ago."
		
		# Case 7: This does not work, since field annotation do not match.
		# Calls entrypoint: (pair %add (nat %valueA) (nat %valueB))
		# Calling Michelson code: CONTRACT %add (pair (nat %a) (nat %b)) ;
		echo "testcase 7"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callWrongAnnot' --arg "(Pair \"Add\" (Pair 1 2))" > result7.tmp 2>&1
		checkResult result7.tmp "At line 116 characters 53 to 61,"

		# Case 8: This works
		# Calls entrypoint: (pair %addNoAnnot nat nat))
		# Calling Michelson code: CONTRACT %add (pair (nat %a) (nat %b))
		echo "testcase 8" 
	 	$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callWrongAnnot' --arg "(Pair \"AddNoAnnot\" (Pair 1 2))" > result8.tmp 2>&1
		checkResult result8.tmp "The operation has only been included 0 blocks ago." 

		# Case 9: This works
		# Calls entrypoint: (pair %addWrongAnnot (nat %a) (nat %b))
		# Calling Michelson code: CCONTRACT %add (pair (nat %a) (nat %b)) 
		echo "testcase 9"
		$TEZOSCLIENT transfer 0 from deploy to addition --entrypoint 'callWrongAnnot' --arg "(Pair \"AddWrongAnnot\" (Pair 1 2))" > result9.tmp 2>&1
		checkResult result9.tmp "The operation has only been included 0 blocks ago."

		;;
esac
rm *.tmp
