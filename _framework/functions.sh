#!/bin/bash

function checkResult () {
	if ! grep -Fxq "$2" $1; then
		echo "testcase failed"
	else 
		echo "testcase succeeded"
	fi
}

main() {
    code
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
    main "$@"
fi