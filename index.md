# Tezos security baseline checking test cases

## An overview of general testcases

- [TC-001: Non-existing KT address](./testcases/TC-001/readme.md)
- [TC-002: Reentrancy - contract balance](./testcases/TC-002/readme.md)
- [TC-002b: Reentrancy - contract balance - test case B](./testcases/TC-002b/readme.md)
- [TC-003: Reentrancy - balance tracked in storage](./testcases/TC-003/readme.md)
- [TC-004: MUTEZ underflow](./testcases/TC-004/readme.md)
- [TC-005: MUTEZ overflow](./testcases/TC-005/readme.md)
- [TC-006: Duplicate operation](./testcases/TC-006/readme.md)
- [TC-007: 0tez transaction to implicit account](./testcases/TC-007/readme.md)
- [TC-008: BALANCE instruction](./testcases/TC-008/readme.md)
- [TC-009: Wrong field annotations](./testcases/TC-009/readme.md)
- [TC-010: Batch operation failing](./testcases/TC-010/readme.md)
- [TC-011: Operation ordering](./testcases/TC-011/readme.md)
- [TC-012: Default entrypoint testing](./testcases/TC-012/readme.md)
- [TC-013: Sending tez to oneself](./testcases/TC-013/readme.md)
- [TC-014: Long entrypoint names](./testcases/TC-014/readme.md)
- [TC-015: PUSH contract](./testcases/TC-015/readme.md)
- [TC-016: IS_IMPLICIT_ACCOUNT and IMPLICIT_ACCOUNT](./testcases/TC-016/readme.md)
- [TC-016: VOTING_POWER](./testcases/TC-016/readme.md)

## Overview of ticket testcases

- [TC-T-001: Tickets - Duplicate ticket - dup](./testcases/TC-T-001/readme.md)
- [TC-T-002: Tickets - Duplicate ticket - dup-n2](./testcases/TC-T-002/readme.md)
- [TC-T-003: Tickets - Duplicate ticket - dup-n10](./testcases/TC-T-003/readme.md)
- [TC-T-004: Tickets - Duplicate ticket - dup list](./testcases/TC-T-004/readme.md)
- [TC-T-005: Tickets - Duplicate ticket - pack](./testcases/TC-T-005/readme.md)
- [TC-T-006: Tickets - Duplicate ticket - pack pair](./testcases/TC-T-006/readme.md)
- [TC-T-007: Tickets - Duplicate ticket - on-chain view](./testcases/TC-T-007/readme.md)
- [TC-T-008: Tickets - Create ticket - callback case 1 - address](./testcases/TC-T-008/readme.md)
- [TC-T-009: Tickets - Create ticket - callback case 2 - address and option](./testcases/TC-T-009/readme.md)
- [TC-T-010: Tickets - Create ticket - callback case 3 - string and option](./testcases/TC-T-010/readme.md)
- [TC-T-011: Tickets - Create ticket - callback case 4 - string](./testcases/TC-T-011/readme.md)
- [TC-T-012: Tickets - Create ticket - lambda case 1 - address](./testcases/TC-T-012/readme.md)
- [TC-T-013: Tickets - Create ticket - lambda case 2 - address and option](./testcases/TC-T-013/readme.md)
- [TC-T-014: Tickets - Create ticket - lambda case 3 - string and option](./testcases/TC-T-014/readme.md)
- [TC-T-015: Tickets - Create ticket - lambda case 4 - string](./testcases/TC-T-015/readme.md)
- [TC-T-016: Tickets - Originate ticket - address](./testcases/TC-T-016/readme.md)
- [TC-T-017: Tickets - Originate ticket - string](./testcases/TC-T-017/readme.md)
- [TC-T-018: Tickets - Create ticket - call input string](./testcases/TC-T-018/readme.md)
- [TC-T-019: Tickets - Create ticket - call input option string](./testcases/TC-T-019/readme.md)
- [TC-T-020: Tickets - Join ticket - two different ticketers](./testcases/TC-T-020/readme.md)
- [TC-T-021: Tickets - Join ticket - two different, but similar cty](./testcases/TC-T-021/readme.md)
- [TC-T-022: Tickets - Duplicate ticket - duplicate transaction operation](./testcases/TC-T-022/readme.md)
- [TC-T-023: Tickets - Duplicate ticket - duplicate map containing tickets](./testcases/TC-T-023/readme.md)
- [TC-T-024: Tickets - Duplicate ticket - duplicate big_map containing tickets](./testcases/TC-T-024/readme.md)
- [TC-T-025: Tickets - Zero amount ticket](./testcases/TC-T-025/readme.md)
- [TC-T-026: Tickets - Send tickets from smart contract to implicit](./testcases/TC-T-026/readme.md)

## Overview of on-chain view testcases

- [TC-V-001: On-chain view - Manipulate caller stack - add](./testcases/TC-V-001/readme.md)
- [TC-V-002: On-chain view - Manipulate caller stack - dig](./testcases/TC-V-002/readme.md)
- [TC-V-003: On-chain view - Manipulate caller stack - dup](./testcases/TC-V-003/readme.md)

## Overview of Ligo testcases

- [TCL-001: Operation ordering](./testcases/TCL-001/readme.md)

## Overview of Smart Optimistic Rollup testcases

- [TCR-001: Smart optimistic rollup - sending transaction by octez-client](./testcases/TCR-001/readme.md)
- [TCR-002: Smart optimistic rollup - sending tez from a contract](./testcases/TCR-002/readme.md)
- [TCR-003: Smart optimistic rollup - sending wrong input parameter type](./testcases/TCR-003/readme.md)
- [TCR-004: Smart optimistic rollup - Call smart rollup from implicit account (like a smart contract)](./testcases/TCR-004/readme.md)
- [TCR-005: Smart optimistic rollup - Bytes instead of tickets](./testcases/TCR-005/readme.md)

## Overview of SmartPy testcases

- [TCS-001: Operation ordering - in entrypoint code](./testcases/TCS-001/readme.md)
- [TCS-002: Operation ordering - in lambda code](./testcases/TCS-002/readme.md)
- [TCS-003: Operation ordering - mixed](./testcases/TCS-003/readme.md)
- Deprecated: [TCS-004: Python control statements - bool testcase](./testcases/old/_TCS-004/readme.md)
- Deprecated: [TCS-005: Python control statements - value testcase](./testcases/old_TCS-005/readme.md)
- [TCS-006: Operation ordering - external lambdas](./testcases/TCS-006/readme.md)
- [TCS-007: Similar operators](./testcases/TCS-007/readme.md)