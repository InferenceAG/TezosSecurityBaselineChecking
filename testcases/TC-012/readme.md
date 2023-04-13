# Testcase title: Default entrypoint testing

## Description
This scenario contains three different contracts, to check how the protocol behaves when looking for the default entrypoint of a contract.

### Structure of the test
    - singleEP.tz: has only one EP, which was not marked as the default one;
    - twoEP_withDefault.tz: has two EPs, one of them was marked as the default one
    - twoEP_noDefault.tz: has two EPs, but none of them was marked as the default one.

### Expected results
    - singleEP.tz: the protocol should pick the only EP as the default one. The contract attempts a self transfer, triggering the execution of its only EP, which attempts, again, a self transfer. It's an infinite loop leading to a gas exhaustion failure;
    - twoEP_withDefault.tz: one of the EPs was marked as default, so the test should complete with a success, executing the default EP;
    - twoEP_noDefault.tz: the test should fail. There is no default EP, so the protocol cannot determine which one to use to resolve the contract call. Instead of picking a random one, the operation fails and reverts.

