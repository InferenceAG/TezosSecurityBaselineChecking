# Testcase title: Smartpy - operation ordering - basic

## Description
Testcase checks whether the Tezos operation ordering is still the same.

Operation are handed over to the blockchain in a LIST. The operations in the list will be executed from left to right.

For instance, a smart contract generating the list [ op1; op2 ; op3] will emit 1.) the op1 operation, 2.) op2 operation, and finally 3.) op3 operation.

The current testcase creates the following list of operations: [ transfer 1 tez; transfer 2 tez; transfer 3 tez]. (Note: Instruction "CONS" is prepending elements to a list.)