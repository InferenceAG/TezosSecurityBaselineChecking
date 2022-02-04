# Testcase title: Tickets - Create ticket - input option string/address

## Description
Naively* trying to create an own ticket from scratch.

We assume that the ticket is just a (option (pair string cty nat)) or (option (pair address cty nat))and can "easily" be created by crafting a transaction to call the entrypoint with this parameter as input.

* Naively - meaning: WE just try it without thinking whether this test makes sense in regards with the used underlying architecture. We think of the underlying architecture (type system, stack separation, etc.) as a black box.