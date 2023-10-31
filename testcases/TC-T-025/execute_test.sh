#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "zeroticket"

case $1 in
	oxford)
		echo "executing tests for $1"

		echo "## Sub testcase #1:"
		# Creation of a zero ticket
		$TEZOSCLIENT originate contract zeroticket transferring 0 from deploy running tickets_zero_amount.tz --init "Unit" --burn-cap 0.1 --force  >out.tmp 2>&1
		
		$TEZOSCLIENT transfer 0 from deploy to zeroticket --entrypoint "default" --arg "Unit" >result1.tmp 2>&1
		checkResult result1.tmp "with \"error should actually fail\""


		echo "## Sub testcase #2:"
		# Split a ticket of 1 quantity into two tickets ( 0 and 1 quantity). 
		$TEZOSCLIENT originate contract zerosplitticket transferring 0 from deploy running tickets_split_to_zero.tz --init "Unit" --burn-cap 1 --force  >out2.tmp 2>&1

		$TEZOSCLIENT transfer 0 from deploy to zerosplitticket --entrypoint "default" --arg "Unit" >result2.tmp 2>&1
		checkResult result2.tmp "with \"error should actually fail\""
		

		echo "## Sub testcase #3:"
		# Sending of a ticket of zero quantity from a implicit account
		$TEZOSCLIENT originate contract ticketSender transferring 0 from deploy running tickets_ticket.tz --init "Unit" --burn-cap 1 --force  >out3.tmp 2>&1
		deployAddress=$($TEZOSCLIENT list known addresses |grep deploy | awk '{print $2}')
		$TEZOSCLIENT transfer 0 from deploy to ticketSender --entrypoint "default" --arg "\"$deployAddress\"" >result3.tmp 2>&1
		adminAddress=$($TEZOSCLIENT list known addresses |grep admin | awk '{print $2}')

		$TEZOSCLIENT transfer 0 tickets from deploy to $adminAddress with entrypoint default and contents '"test"' and type string and ticketer ticketSender --burn-cap 1 >result5.tmp 2>&1
		checkResult result5.tmp "  ticket quantity should not be zero or negative"		

		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp