---
name: task-decomposition
description: Breaks an approved spec into small, independently shippable tasks with dependencies mapped. Produces task graphs with effort estimates and verification criteria. WHEN to use it - planning new features or epics, breaking down vague requirements, estimating work, identifying dependencies, or planning parallel work streams.
license: MIT
metadata:
  category: product
  handoff-from:
    - pm
    - arch
  handoff-to:
    - dev
    - memory
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @task-decomposition — Breaking Down Work

**Philosophy:** Make the change easy, then make the easy change. Large features are risky; small incremental changes are safe.

## When to invoke
- Planning new features or epics
- Breaking down vague requirements
- Estimating work effort
- Identifying dependencies
- Planning parallel work streams

## Responsibilities
- Decompose large features into small, testable tasks
- Identify dependencies between tasks
- Estimate effort for agentic development
- Determine what can be done in parallel
- Define verification criteria for each task

## Boundary with `@pm`
- `@task-decomposition` assumes scope and acceptance criteria already exist (usually from `@pm`).
- If scope is unclear, hand back to `@pm` instead of inventing requirements.
- Focus on execution units and validation steps, not product prioritization.

---

## Core Principles

### 1. Vertical Slices Over Horizontal Layers
Build one complete feature slice at a time (model + API + UI + test), not all models first, then all APIs. Each slice is independently deployable, testable, and reduces integration risk.

### 2. Small, Independently Testable Tasks
Each task should be completable in 1-4 hours, have clear acceptance criteria, leave the system in a working state, and be independently deployable (with feature flag if needed).

### 3. Dependencies First, Features Second
Identify blockers before starting work. Map what blocks what, then identify what can be done in parallel (frontend mockups, documentation, test scaffolding).

---

## Process & Examples

Load `references/examples.md` for:
- 6-step decomposition process with worked examples (search feature, user registration)
- Effort estimate guide (Simple 30min → Very Complex 4h+)
- Verification criteria example
- Task template (markdown format)

---

## Red Flags (Task Too Large)

Break down further if:
- Estimate > 4 hours
- Acceptance criteria > 10 items
- Description > 3 sentences
- Multiple "and" in task title
- Touches > 5 files
- Requires > 2 different skills

---

## Artifact
Append the task graph to `spec.md` (as a new section) or deliver as a standalone task-list document. Format: task name, component, effort estimate, dependencies, acceptance criteria, verification method.

## Handoffs
- **From `@pm`** → `spec.md` with acceptance criteria is the input
- **From `@arch`** → `tech-spec.md` provides technical constraints
- **To `@dev`** → Individual tasks with verification criteria
- **To `@memory`** → Log decomposition decisions for session continuity

## Checklist

- [ ] Each task is 1-4 hours
- [ ] Each task has clear acceptance criteria
- [ ] Dependencies are identified
- [ ] Parallel work opportunities identified
- [ ] Each task leaves system in working state
- [ ] Each task is independently testable
- [ ] Verification criteria defined
