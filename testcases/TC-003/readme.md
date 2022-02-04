# Testcase title: Reentrancy - balance tracked in storage

## Description
To check whether storage' parameters are immediately adjusted when transaction operation executing the "payout" entrypoint has been finished.

## Testcase content
Testcase originates a contract with a "payout" entrypoint. When calling the payout entrypoint all available tez amount except of an "minLockedValue" can be transferred to a provied destination address. 

The testcase tries to transfer the amount to an "attackerContract", which immediately calls again the "payout" entrypoint. The hope of the attacker is that the balance stored in storage has not yet been updated.

The attacker should not be successful in doing that, since the balance in the storage is immediately updated, when transaction operation executing the "payout" entrypoint has been finished. Any reentrancy (after the transaction operation) to the contract finds the updated balance in storage.