# Testcase title: Non-existing KT address

## Description
To check whether non-existing KT addresses can not be prefunded.

## Background
Prefunding non-exising KT addresses may result in some weaknesses, since initial (at origination) assumed state of a contract may be wrong.

However, even though prefunding would be possible, abusing this may get difficult in a real world scenario, since KT address are difficult to predict: https://tezos.stackexchange.com/questions/1941/how-are-the-originated-contract-addreses-kt1-computed