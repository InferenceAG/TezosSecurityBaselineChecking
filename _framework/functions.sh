#!/bin/bash

function checkResult () {
	if ! grep -Fxq "$2" $1; then
		echo "testcase failed"
	else 
		echo "testcase succeeded"
	fi
}

function getDirName () {
	dirname="$(basename "$(pwd)")"
	echo $dirname
}

function getReadmeHead () {
	readmehead="$(head -n 1 readme.md)"
	echo $readmehead
}

function getTestcaseTitle () {
	readmehead=$(getReadmeHead)
	dirname=$(getDirName)

	echo $dirname $readmehead
}

function removeContract () {
	test=$($TEZOSCLIENT list known contracts |grep $1|awk -F ":" '{print $1}')
	if [[ $test == $1 ]]; then
		$TEZOSCLIENT forget contract $1
	fi
}

main() {
    code
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
    main "$@"
fi
