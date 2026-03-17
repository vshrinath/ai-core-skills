---
name: self-review
description: Pre-handoff quality check before requesting code review. Reviews code for mistakes, tests, linting, and conventions. WHEN to use it - after completing implementation, before requesting code review, before merging to main branch, after fixing bugs, or before deploying to production.
license: MIT
metadata:
  category: coding
  handoff-from:
    - dev
  handoff-to:
    - guard
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @self-review — Pre-Handoff Quality Check

**Philosophy:** Catch your own mistakes before others do. The best code review is the one you don't need.

## When to invoke
- After completing implementation
- Before requesting code review
- Before merging to main branch
- After fixing bugs
- Before deploying to production

## Responsibilities
- Review own code for common mistakes
- Verify tests pass and cover edge cases
- Check adherence to conventions
- Validate security and performance
- Ensure documentation is updated

## Boundary with `@guard`
- `@self-review` is the author's internal pre-check before requesting review.
- `@guard` is the independent audit pass used for review and merge readiness.
- Do not replace `@guard` with `@self-review` on non-trivial changes.

---

## Self-Review Checklist

Run through the same areas `@guard` checks (load `@guard`'s `references/checklist.md` for the full list):

1. **Security:** No hardcoded secrets, input validated, safe queries, proper auth.
2. **Correctness:** Logic sound, edge cases and nulls handled, no off-by-one errors.
3. **Performance:** Efficient queries, no N+1, optimized bundles, lazy loading.
4. **Code Quality:** Small functions, clear names, DRY, no magic numbers.
5. **Testing:** Unit tests pass, edge cases covered, mocks used appropriately.
6. **Error Handling:** Fail loud, helpful messages, no swallowed exceptions.
7. **Documentation:** READMEs, API docs, and architecture notes updated.
8. **Conventions:** Follows `CONVENTIONS.md`, passes all linters and formatters.
9. **Deployment Safety:** Backward-compatible migrations, feature flagged if risky.

---

## Self-Review Process

### Step 1: Read Your Own Code
Pretend you're reviewing someone else's code. Ask: Would I understand this in 6 months? Is this the simplest solution? What could go wrong? What edge cases am I missing?

### Step 2: Run All Checks

```bash
npm test         # or pytest, go test
npm run lint     # or ruff, eslint
tsc --noEmit     # or mypy, pyright
npm audit        # or bandit, trivy
npm run format:check
```

### Step 3: Manual Testing

Test scenarios: happy path, empty input, invalid input, boundary conditions (0, -1, max value), concurrent access (if applicable).

### Step 4: Review Changes

```bash
git diff         # View your changes
git status       # Check what files changed
```

Does every change belong in this PR? Any debug code left in? Any commented-out code or console.log/print statements?

### Step 5: Write Self-Review Notes

```markdown
## Self-Review Notes

### What I Changed
- [Brief description]

### Testing Done
- [x] Unit tests pass
- [x] Manual testing completed
- [x] Edge cases tested

### Confidence Level
- 85% - Mostly confident, but uncertain about [specific thing]

### Questions for Reviewer
1. Is [approach] the right way to handle [scenario]?

### Known Issues
- [Issue 1] - Will fix in follow-up PR
```

---

## Common Findings

Load `references/patterns.md` for: common self-review findings with before/after code examples (hardcoded secrets, N+1 queries, off-by-one errors, missing error handling) and self-review anti-patterns to avoid.

---

## Artifact
`@self-review` is an in-place annotator — it modifies the diff or implementation notes directly rather than producing a new file. Append self-review notes to `implementation-notes.md` or include in the PR description.

## Checklist: Ready for Review

- [ ] All self-review checks passed
- [ ] Tests pass locally
- [ ] Linting passes
- [ ] Manual testing completed
- [ ] Documentation updated
- [ ] Commit message is clear
- [ ] Confidence level documented
