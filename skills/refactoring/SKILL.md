---
name: refactoring
description: Safe structural cleanup without behavior change. Identifies code smells, removes duplication, and improves clarity. WHEN to use it - when code smells are detected, before adding features to messy code, after feature work to clean up, during code review when patterns emerge, or quarterly for code health audits.
license: MIT
metadata:
  category: coding
  handoff-from:
    - dev
    - guard
  handoff-to:
    - testing
    - qa
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @refactoring — Safe Code Refactoring

**Philosophy:** Make the change easy, then make the easy change. Refactoring is not rewriting.

## When to invoke
- Code smells detected (duplication, complexity, unclear naming)
- Before adding new features to messy code
- After feature is working (clean up implementation)
- During code review when patterns emerge
- Quarterly code health audits

## Responsibilities
- Identify code smells and technical debt
- Refactor safely with tests as safety net
- Improve code clarity without changing behavior
- Know when to refactor vs rewrite
- Document refactoring decisions

---

## Core Principles

### 1. Tests First
Never refactor without tests. Workflow: write tests for current behavior → verify pass → refactor → verify pass → commit.

### 2. Small Steps
Refactor in tiny, verifiable increments. Each step touches only the code being changed and is independently verifiable. Never rewrite an entire file — untouched functions can be subtly altered by accident.

### 3. Behavior Preservation
Refactoring changes structure, not behavior. Separate refactoring commits from feature additions and bug fixes. Mixed commits make it impossible to identify what broke tests.

---

## Code Smells & Techniques

Load `references/code-smells.md` for:
- Duplicated code, long functions, large classes, long parameter lists, magic numbers, nested conditionals — each with before/after examples
- Refactoring techniques: extract function, rename variable/function, extract variable — with code examples

---

## When to Refactor vs Rewrite

**Refactor when:**
- Code works but is messy
- Tests exist (or can be added)
- Changes are incremental
- Business logic is sound

**Rewrite when:**
- Technology is obsolete
- No tests and code is incomprehensible
- Architecture is fundamentally broken
- Cost of refactoring > cost of rewriting

---

## Refactoring Workflow

```
1. Identify code smell
2. Write tests (if missing) and verify they pass
3. Make one small refactoring
4. Run tests
5. Commit
6. Repeat from step 3
```

---

## Checklist

### Before
- [ ] Tests exist and pass
- [ ] You understand what the code does
- [ ] You have a clear goal (what smell are you fixing?)
- [ ] Code is in version control

### During
- [ ] Making small, incremental changes
- [ ] Running tests after each change
- [ ] Not adding features or fixing bugs
- [ ] Keeping behavior unchanged

### After
- [ ] All tests still pass
- [ ] Code is more readable and easier to modify
- [ ] No new bugs introduced
