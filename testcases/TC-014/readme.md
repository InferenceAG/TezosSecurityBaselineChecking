# Testcase title: Long entrypoint names

## Description
This scenario attempts to deploy a smart contract with a long entrypoint name.

### Expected results
A contract with a long entrypoint name can not be deployed.


## Notes
Deploying a contract with a long entrypoint name is allowed. However, deploying a contract that calls another contract with a long entrypoint name does not work. This is because the following construct will cause an error during deployment:

CONTRACT %1234567890123456789012345678901234567891012345678901234567890 nat;

Therefore, the only way to access an entrypoint with a long name from another contract is to call the root entrypoint and route internally to the desired entrypoint.

From command line this can be done as follows for the demo contract is this test case:
octez-client call "KT1VzvhJoZL5zFvp3N7qKfa5ymv8bHDFQHvP" from "admin" --arg "Right 1"