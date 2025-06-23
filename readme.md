# Tezos security baseline checking framework 

## WIP WARNING
This is work in progress (WIP). The framework is still in its infancy,
the scripts are unpolished bash, quirky, etc.

We invite you to help. Please see also section "[contribution](#contribution)".

### Ideas & open points & goals
- more flexibility in various aspects
- test cases can be run against different networks, but also against
  the pytezos interpreter, etc.
- test cases can be run at any time
- test cases can be run using different Ligo / SmartPy compilers
- possibility to run only a subset of test cases
- improving result checking
- improving output
- reusing already deployed contracts (mainnet?)
- tracking / comparing changes between different environments/setups
  (protocols, compilers, etc.
- etc.

## Purpose
The purpose of the Tezos security baseline checking framework is to
check whether the underlying system for smart contracts on Tezos
continues to behave as expected.

Performing these checks independently is crucial for smart contract
developers and, in particular, for security assessors in order to
understand how the underlying system is working and whether it has
been changed. Thus, a profound understanding of the underlying system
forms a "baseline" for any security-related work on smart contracts.

For instance the Tezos
[security assessment checklist](https://github.com/Inference/TezosSecurityAssessmentChecklist)
is based on this baseline and can potentially need to be updated as
soon as the underlying system's mechanics have changed.

An additional benefit of this independent security baseline checking
framework is the early detection of critical changes to the
underlying system for smart contract in the development of new Tezos
protocols, high-level smart contract compilers, etc. 

## Test cases
### Overview
An overview over existing test cases can be found in [./index.md](./index.md)

## How to run for Tezos testnets
### Setup
1. Download this repo: `git clone https://github.com/Inference/TezosSecurityBaselineCheckingFramework`
2. Get a
   [tezos-client executable](https://tezos.gitlab.io/introduction/howtoget.html),
   which supports the network where you want to run the test cases on.
3. Install [SmartPy](https://smartpy.io/docs/cli)
4. Install [Ligo](https://ligolang.org/docs/intro/installation)
5. Adapt parameters for SMARTPY, LIGO, and TEZOSCLIENT in the [_framework/init.sh](_framework/init.sh) file.
6. Create test accounts by changing to _framwork directory. E.g. `cd _framework` and execute script `./create_accounts.sh`
7. Go to the corresponding faucet on teztnets.com and get 10'000 tez for each generated account.

### Execute all test cases
1. Change to the _framework directory: `cd _framework`
2. Execute the script `./execute_all.sh`

### Execute a single test case
1. Change to the test case directory. E.g. `cd testcases/TC-001]`
2. Execute the script `./execute_test.sh`

## Contribution
Everyone is invited to contribute to the security baseline checking
framework. We are eager to see new ideas, read new test cases and
foster the development of the framework by everyone in the Tezos
ecosystem.

## Disclaimer
This security baseline checking framework is currently "work in
progress". The security baseline checking framework does not claim to
be complete at any time as it is continuously developed.

## Contact
This github repository is currently maintained by
[Inference](https://inference.ag).