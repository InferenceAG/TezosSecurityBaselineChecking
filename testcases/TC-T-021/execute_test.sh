#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "join"

case $1 in
	oxford)
		echo "executing tests for $1"
		$TEZOSCLIENT originate contract join transferring 0 from deploy running tickets_join.tz --init "Unit" --burn-cap 0.2 --force >out.tmp 2>&1
	  	$TEZOSCLIENT transfer 0 from deploy to join --entrypoint "default" --arg "Unit" >result.tmp 2>&1
		checkResult result.tmp "script reached FAILWITH instruction"
		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp