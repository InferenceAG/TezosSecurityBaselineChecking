# Testcase title: Reentrancy - contract balance - test case B

## Description
To check whether contract balance of a smart contract is only updated when an emitted operation gets processed.

## Testcase content
Testcase originates a contract with a "transfer" entrypoint. When calling the transfer entrypoint all available tez amount except of an "minLockedValue" can be transferred to the caller of the smart contract. In addition the transfer entrypoint also calls the default entrypoint of a smart contract provided as an input parameter.

The execution order of these two emitted operations is:
1. calling default entrypoint of provided contract address
2. transfer tez to callee (SENDER)

Since the transfer of tez is the second operations to be executed, the BALANCE operation provides still the old balance value in case the transfer entrypoint is called before the tez transfer operation. This may could happend, when the called default entrypoint in 1. operation calls the transfer entrypoint again ("reentrancy").

This test cases checks whether behaviour is still the same (successful exeuction), but also shows an example of a successful reentrancy attack, since the vesting contract actually tries to keep a minimal tez amount (minLockedValue).
