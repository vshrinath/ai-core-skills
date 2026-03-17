---
name: decision-framework
description: Evaluates competing technical or product options using explicit criteria. Extracts assumptions, maps risk surfaces, and forces a documented decision. WHEN to use it - architecture decisions with long-term consequences, build vs buy decisions, deployment strategy changes, or any decision with irreversible or high-cost consequences.
license: MIT
metadata:
  category: product
  handoff-from:
    - arch
    - pm
  handoff-to:
    - arch
    - pm
    - cloud
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @decision-framework — Structured Decision Analysis

**Philosophy:** Most bad decisions fail at the assumption layer, not the execution layer. Sharpen assumptions before deciding.

## When to invoke
- Architecture decisions with long-term consequences
- Feature prioritization with unclear tradeoffs
- Technical debt decisions (refactor vs. ship)
- Build vs. buy decisions
- Deployment strategy changes
- Any decision with irreversible or high-cost consequences
- When a decision "feels wrong" but you can't articulate why

## Responsibilities
- Extract and challenge hidden assumptions
- Map risk surface across multiple dimensions
- Generate adversarial counterfactuals
- Identify second-order effects and system coupling
- Surface cognitive distortions and misaligned incentives
- Produce a decision brief with explicit tradeoffs

## Boundary with `@arch`
- `@decision-framework` decides **which option** to choose under uncertainty and tradeoffs.
- `@arch` defines **how to implement** the chosen architecture.
- Use `@decision-framework` when choices are contested or high-stakes; use `@arch` when the decision is already made.

---

## Process

Load `references/process.md` and follow the 7-step process:
1. Decision Clarification — define the decision in one sentence
2. Assumption Extraction — empirical vs speculative, reversible vs irreversible
3. Distortion & Incentive Scan — check for cognitive biases
4. Adversarial Counterfactual — generate the strongest case against
5. Risk Surface Mapping — probability, impact, detectability, mitigation
6. Second-Order & System Effects — coupling, lock-in, what becomes harder
7. Decision Brief — one-page output with recommendation, tradeoffs, risks, failure mode

---

## Rules

- **Empirical assumptions must be verified.** Don't proceed on speculation when you can test.
- **Irreversible assumptions must be challenged.** These are the ones that lock you in.
- **Late-detectable, high-impact risks are the killers.** Prioritize mitigation here.
- **The failure narrative must be specific.** "We failed because we didn't plan well" is useless.
- **The decision brief must fit on one page.** If it's longer, the decision is too complex or poorly scoped.

## When NOT to use this framework

- **Small, reversible decisions:** If you can undo it in a day, just try it.
- **Decisions with obvious answers:** If there's no real tradeoff, don't force one.
- **When speed matters more than correctness:** Sometimes you need to move fast and accept risk.

## Artifact
Write the Decision Brief to `decision-brief.md` in the project root. Must include: decision, recommendation, tradeoffs (gains and costs), key assumptions, top risks with mitigations, failure mode, reversibility, and open questions.

## Handoffs
- **To `@arch`** → When the decision is architectural (system design, service boundaries, data models)
- **To `@pm`** → When the decision is about scope or prioritization
- **To `@cloud`** → When the decision is about deployment, infrastructure, or operational risk
- **Back to stakeholders** → When assumptions can't be verified without their input
