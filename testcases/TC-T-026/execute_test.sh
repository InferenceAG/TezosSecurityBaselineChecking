#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "ticketSender"

case $1 in
	oxford)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract ticketSender transferring 0 from deploy running ticketSender.tz --init "Unit" --burn-cap 1 --force  >out.tmp 2>&1
		
		echo "## Sub testcase #1:"
		# Sending ticket from contract to implicit.
		$TEZOSCLIENT transfer 0 from deploy to ticketSender --entrypoint "callA" --arg "Unit" --burn-cap 1 >transfer1.tmp 2>&1
		# Sending ticket from contract to implicit, but different entrypoint.
		$TEZOSCLIENT transfer 0 from deploy to ticketSender --entrypoint "callB" --arg "Unit" --burn-cap 1 >transfer2.tmp 2>&1
		$TEZOSCLIENT get ticket balance for deploy with ticketer ticketSender and type string and content '"One"' >result1.tmp 2>&1
		checkResult result1.tmp "20"

		echo "## Sub testcase #2:"
		# Sending ticket from contract to implicit, but different entrypoint.
		$TEZOSCLIENT transfer 0 from deploy to ticketSender --entrypoint "callC" --arg "Unit" --burn-cap 1 >transfer3.tmp 2>&1
		checkResult transfer3.tmp "At line 39 characters 48 to 56,"

		echo "## Sub testcase #3:"
		# Sending ticket from implicit to another implicit.
		$TEZOSCLIENT transfer 1 tickets from deploy to admin with entrypoint default and contents '"One"' and type string and ticketer ticketSender --burn-cap 1 >transfer4.tmp 2>&1
		$TEZOSCLIENT get ticket balance for deploy with ticketer ticketSender and type string and content '"One"' >result3.tmp 2>&1
		checkResult result3.tmp "19"

		echo "## Sub testcase #4:"
		# Sending ticket from implicit to contract.
		$TEZOSCLIENT transfer 1 tickets from deploy to ticketSender with entrypoint "ticket" and contents '"One"' and type string and ticketer ticketSender --burn-cap 1 >transfer5.tmp 2>&1
		$TEZOSCLIENT get ticket balance for deploy with ticketer ticketSender and type string and content '"One"' >result4.tmp 2>&1
		checkResult result4.tmp "18"
		
		echo "## Sub testcase #5:"
		# Expected result "0", since the contract does not store the ticket.
		$TEZOSCLIENT get ticket balance for ticketSender with ticketer ticketSender and type string and content '"One"' >result5.tmp 2>&1
		checkResult result5.tmp "0"

		echo "## Sub testcase #6:"
		# Failing since too many tickets than available are trying to be sent to an implicit.
		$TEZOSCLIENT transfer 19 tickets from deploy to admin with entrypoint default and contents '"One"' and type string and ticketer ticketSender --burn-cap 1 >transfer6.tmp 2>&1
		checkResult transfer6.tmp "      This operation FAILED."

		echo "## Sub testcase #7:"
		# Failing since too many tickets than available are trying to be sent to contract.
		$TEZOSCLIENT transfer 19 tickets from deploy to ticketSender with entrypoint "ticket" and contents '"One"' and type string and ticketer ticketSender --burn-cap 1 >transfer7.tmp 2>&1
		checkResult transfer7.tmp "      This operation FAILED."

		echo "## Sub testcase #8:"
		# Sending a ticket to a "non-existing" resp. a not revealed implicit account.
		$TEZOSCLIENT transfer 1 tickets from deploy to tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU with entrypoint default and contents '"One"' and type string and ticketer ticketSender --burn-cap 1 >transfer8.tmp 2>&1
		checkResult transfer8.tmp "Operation successfully injected in the node."

		echo "## Sub testcase #9:"
		# Sending a ticket to a "non-existing" contract.
		# TODO: Contract KT1TxqZ8QtKvLu3V3JH7Gx58n7Co8pgtpQU5 is the Sirius contract on mainnet. This contract address should be replaced, if the test suite should run on mainnet.
		$TEZOSCLIENT transfer 1 tickets from deploy to KT1TxqZ8QtKvLu3V3JH7Gx58n7Co8pgtpQU5 with entrypoint default and contents '"One"' and type string and ticketer ticketSender --burn-cap 1 >transfer9.tmp 2>&1
		checkResult transfer9.tmp "          This operation FAILED."
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp
