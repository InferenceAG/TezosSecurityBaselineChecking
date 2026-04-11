# Security Standard

---

## What This Framework Handles

This framework runs tests against live Tezos testnets using real funded accounts.
The security risks are therefore primarily around **key exposure** and
**testnet fund loss** rather than production data.

---

## Hard Rules (Never Do)

| Rule                                                          | Reason                                              |
|---------------------------------------------------------------|-----------------------------------------------------|
| Never commit `init.local.sh`                                  | Contains paths that may reveal system layout        |
| Never commit private keys or mnemonics                        | Immediate fund loss on any testnet                  |
| Never commit funded account addresses or aliases              | Allows targeted draining                            |
| Never commit `.env` files with real values                    | Same as above                                       |
| Never automate faucet requests                                | Rate-limited; ToS violation on most testnets        |
| Never use `--no-verify` on git commits                        | Bypasses pre-commit hooks designed to catch secrets |
| Never force-push to `master`                                  | Risk of overwriting others' work                    |

---

## Gitignore Policy

The following patterns must remain in `.gitignore`:

```
_framework/init.local.sh
results/*.out
results/*.log
```

Do not remove these entries. If you find secrets accidentally staged, use
`git rm --cached` to unstage and clean before committing.

---

## Test Account Security

- Accounts are funded with test tez only. Do not use mainnet accounts.
- The minimum balance to run tests is 100 tez per account.
- After finishing work on a test branch, you do not need to zero the balances
  (testnet tez has no monetary value), but do not share funded account keys.
- If you believe an account key has been exposed (accidentally committed),
  treat the account as compromised and create a new one.

---

## RPC Endpoint Security

- Public RPC endpoints are safe to commit (they are in the network profiles).
- If you use a private or authenticated RPC endpoint, its URL and any credentials
  must live only in `init.local.sh`.
- Do not use mainnet RPC endpoints in automated tests — they do not provide test
  accounts and tests may fail or cost real tez.

---

## Dependency Security

- Tool versions are pinned in `_framework/versions.sh`. Do not silently upgrade
  without updating this file and verifying tests still pass.
- Docker base image should be pinned to a specific digest or version tag, not `latest`.

---

## What Agents May Do Without Asking

- Read any file in the repository
- Edit test scripts, framework files, and documentation
- Run `make lint` and `make test` (if environment is configured)
- Create branches

## What Agents Must Ask a Human Before Doing

- Pushing to any remote branch
- Merging or closing pull requests
- Modifying `.gitignore` to stop ignoring a sensitive file
- Any change that affects credentials handling or secret detection

## What Agents Must Never Do

- Commit or stage `init.local.sh`, private keys, or account details
- Bypass git hooks (`--no-verify`)
- Force-push to `master`
- Weaken or remove entries from `.gitignore`
