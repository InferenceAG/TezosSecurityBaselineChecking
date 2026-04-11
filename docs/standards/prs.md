# Pull Request Standard

---

## When to Open a PR

- Adding one or more new test cases
- Changing framework scripts (`_framework/`)
- Updating documentation
- Any change intended to land on `master`

---

## PR Title

Follow the same Conventional Commits format used for commit messages:

```
feat(TC-027): verify <behaviour>
fix(TCS-003): correct expected operation ordering
docs: add AICD required documentation structure
```

Max 72 characters. Imperative mood. No trailing period.

---

## PR Body Template

```markdown
## Summary

- [What changed and why — one bullet per logical change]

## Test plan

- [ ] Ran `make lint` — all scripts pass shellcheck
- [ ] Ran the new/modified test manually against a live testnet
- [ ] Reviewed output for correctness, not just absence of failure
- [ ] Updated index.md if a new test case was added

## Checklist

- [ ] `execute_test.sh`, `readme.md`, and contract files present for each new test
- [ ] `readme.md` has a populated **Expected Result** section
- [ ] No hardcoded absolute paths in committed files
- [ ] No private keys, funded account addresses, or `init.local.sh` committed
- [ ] No machine-specific paths (e.g. `/home/username/...`)
- [ ] Documentation updated if framework behaviour changed
```

---

## Review Criteria

Reviewers check:

1. **Correctness** — does the test actually verify what the readme claims?
2. **Shellcheck** — does `make lint` pass with no warnings?
3. **No secrets** — no keys, addresses, or local paths committed
4. **Readme quality** — Description, Background, and Expected Result are populated
   and accurate
5. **Index updated** — `index.md` includes the new test case

---

## Merge Policy

- Squash or rebase before merge — keep `master` history linear and clean.
- Do not merge your own PR unless you are the sole maintainer.
- Do not force-push to `master`.
