---
name: debugging
description: Investigates bugs with systematic root cause analysis using hypothesis testing. Does not fix — diagnoses and hands off. WHEN to use it - bug reports in production or development, unexpected behavior or errors, intermittent failures, performance degradation, or after failed deployment.
license: MIT
metadata:
  category: coding
  handoff-from:
    - qa
    - guard
  handoff-to:
    - dev
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @debugging — Systematic Debugging

**Philosophy:** Debugging is hypothesis testing, not random code changes. Understand the problem before attempting a fix.

## When to invoke
- Bug reports (production or development)
- Unexpected behavior or errors
- Intermittent failures
- Performance degradation
- After failed deployment

## Responsibilities
- Reproduce the issue reliably
- Form and test hypotheses systematically
- Identify root cause (not just symptoms)
- Verify fix doesn't introduce regressions
- Document findings for future reference

---

## The Debugging Process

### 1. Reproduce the Issue

**You can't fix what you can't reproduce.**

Document the reproduction:
- Exact steps, with specific data and environment
- Expected vs actual behavior
- Frequency: Always / Sometimes / Rarely

If intermittent: note patterns (time of day, specific users, data conditions), increase logging, find minimal reproduction case.

### 2. Gather Information

**Collect evidence before forming theories.**

Gather: error messages (full stack trace), logs (application, server, database), request/response data, user actions, environment (browser, OS, device), recent changes (deployments, config, data).

### 3. Form Hypothesis

```
Hypothesis: The error occurs because [specific reason]

Evidence supporting:
- [Observation 1]

Evidence against:
- [Observation 2]

Test: [How to verify]
```

### 4. Test Hypothesis

Add logging, use debugger breakpoints, simplify inputs, change one variable at a time, compare working vs broken scenarios.

### 5. Fix and Verify

1. Write a test that reproduces the bug
2. Implement fix
3. Verify test passes
4. Run full test suite
5. Deploy to staging and verify
6. Document the fix

---

## Techniques & Tools

Load `references/techniques.md` for:
- Binary search debugging, differential debugging, time travel debugging (git bisect)
- Logging strategy with examples
- Common bug patterns (off-by-one, null handling, race conditions, timezone issues)
- Interactive debuggers, browser DevTools, production debugging rules

---

## Debugging Checklist

### Before Starting
- [ ] Can you reproduce the issue?
- [ ] Do you have the full error message?
- [ ] Do you have relevant logs?
- [ ] What changed recently?

### During Debugging
- [ ] Have you formed a hypothesis?
- [ ] Have you tested the hypothesis?
- [ ] Are you changing one thing at a time?

### After Fixing
- [ ] Did you write a test that reproduces the bug?
- [ ] Did you run the full test suite?
- [ ] Did you document the root cause?

---

## When to Ask for Help

Ask when:
- Stuck for > 2 hours with no progress
- Issue is outside your expertise (infrastructure, security)
- Production is down (escalate immediately)

Before asking: document what you've tried, provide reproduction steps, share relevant logs/errors, state your current hypothesis.
