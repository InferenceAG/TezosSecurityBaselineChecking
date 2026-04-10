# Testcase title: TC-XXX: Title

## Category
<!-- Choose one: General | Tickets | On-chain Views | Ligo | SmartPy | Rollups -->

## Description
What this test case verifies (1-3 sentences).

## Background
Why this behaviour matters for security or protocol correctness.
Include links to relevant Tezos documentation, Michelson reference, or previous incidents where applicable.

## Test Procedure
Step-by-step description of what the test does:
1. Deploy contract(s) ...
2. Invoke entrypoint with ...
3. Verify that ...

## Expected Result
| Sub-test | Expected outcome | Pass condition |
|----------|-----------------|----------------|
| #1 | Operation succeeds / fails | String found in output: `...` |
| #2 | Operation rejected | Error message contains: `...` |

Clearly state whether a test expects **success** or **failure**, and what specific output constitutes a pass.

## Related Test Cases
<!-- Links to related TCs, if applicable -->
- [TC-XXX](../TC-XXX/readme.md) — reason for relation
