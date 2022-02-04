# Testcase title: On-chain view - add instruction

## Description
To check whether we can access the stack of the caller by using the instruction "add".

## Background
This "naive*" testcase assumes that the on-chain view stack is not correctly separated from the caller's stack. 

Thus, this testcase assumes that there is only one stack, whereas the elements of the on-chain stack are on top. 


* Naive - meaning: WE just try it without thinking whether this test makes sense in regards with the used underlying architecture. We think of the underlying architecture (type system, stack separation, etc.) as a black box.
