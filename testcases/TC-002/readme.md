# Testcase title: Reentrancy - contract balance

## Description
To check whether contract balance is immediately adjusted when a transaction operation is initiated.

## Testcase content
Testcase originates a contract with a "payout" entrypoint. When calling the payout entrypoint all available tez amount except of an "minLockedValue" can be transferred to a provided destination address. 

The testcase tries to transfer the amount to an "attackerContract", which immediately calls again the "payout" entrypoint. The hope of the attacker is that the balance has not yet been updated.

The attacker should not be successful in doing that, since the balance is immediately updated, when the transfer transaction operation has been executed. Any reentrancy (after the transfer transaction operation) to the contract finds the updated balance.