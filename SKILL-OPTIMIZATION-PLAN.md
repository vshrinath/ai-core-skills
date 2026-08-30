# Skill Optimization Plan
**Based on: The Complete Guide to Building Skills for Claude**

Last updated: 2026-03-17

---

## Executive Summary

You have **33 skills** documented as markdown files across 6 domains. **NONE are in proper Claude Skills format**. This plan converts them systematically using the PDF guide's standards.

**Key Requirements from PDF:**
- SKILL.md (exact case-sensitive naming)
- YAML frontmatter with `name` (kebab-case) and `description` (WHAT + WHEN)
- Folder structure: `skill-name/SKILL.md` + optional `references/`, `scripts/`, `assets/`
- Progressive disclosure: Keep SKILL.md < 5,000 words
- No README.md inside skill folders
- Security: No XML tags (< >), no "claude"/"anthropic" in name

---

## Current State Assessment

### Skills Inventory by Category

| Category | Count | Skills |
|----------|-------|--------|
| **Product** | 4 | pm, red-team, task-decomposition, decision-framework |
| **Design** | 2 | ux, accessibility |
| **Coding** | 11 | arch, dev, api-design, data-modeling, git-workflow, guard, qa, self-review, debugging, refactoring, performance, frontend-performance, testing |
| **Marketing** | 5 | writer, seo, perf, video-ai, video |
| **Meta** | 4 | memory, confidence-scoring, context-strategy, error-recovery |
| **Ops** | 3 | deployment-practices, cicd-pipelines, cloud |
| **Brand** | 1 | brand-template |

### Issues Found

#### 1. **No YAML Frontmatter**
- ❌ No `name` field in kebab-case
- ❌ No `description` field with trigger phrases
- ❌ No `license` or `metadata` fields
- ⚠️ Each skill is just a `.md` file, not a folder structure

#### 2. **Descriptions Missing Trigger Phrases**
Example: `@guard` file has no description that says "Use when reviewing code for security vulnerabilities"

#### 3. **No Folder Structure**
Current: `/coding/guard.md`
Needed: `/skills/guard/SKILL.md` + `/skills/guard/references/`

#### 4. **Content Too Long for Single SKILL.md**
- `@guard.md` = 303 lines (good example to modularize)
- `@dev.md` = 202 lines (should move examples to references/)
- `@arch.md` = likely 300+ lines

#### 5. **Security Compliance**
- ✅ No XML tags detected
- ✅ No "claude"/"anthropic" in names
- ⚠️ Need to verify all descriptions under 1024 characters

---

## Implementation Plan: 6 Phases

### Phase 1: Create Folder Structure
**Time: 1-2 hours**

For each of 33 skills, create:
```
skills/
├── arch/
│   ├── SKILL.md (core instructions)
│   ├── references/
│   │   ├── patterns.md
│   │   ├── checklists.md
│   │   └── examples.md
│   └── assets/ (if needed)
├── dev/
├── guard/
... (repeat for all 33)
```

**Action Steps:**
1. Create `skills/` directory at root
2. For each skill `{domain}/{skillname}.md`:
   - Create `skills/{skillname}/`
   - Move content into `SKILL.md`
   - Create `references/` folder
   - Extract long sections to `references/{topic}.md`

---

### Phase 2: Write YAML Frontmatter
**Time: 3-4 hours**

For each skill, add frontmatter following the format:
```yaml
---
name: skill-name-in-kebab-case
description: [WHAT] + [WHEN/TRIGGERS] + [KEY CAPABILITIES]
license: MIT
metadata:
  category: product|design|coding|marketing|meta|ops
  author: Virtual Product Factory
  version: 1.0.0
  handoff-from: [skill before this in chain]
  handoff-to: [skill after this in chain]
---
```

#### Description Template by Category

**Product Skills (3 examples)**
```yaml
description: "Translates vague product ideas into scoped, testable specifications with clear acceptance criteria. Use when starting a feature, have ambiguous requirements, or need to force a documented decision on scope. Works with @red-team for adversarial review and @ux for design specifications."
```

```yaml
description: "Adversarial audit of specifications before build. Identifies second-order risks, unsupported assumptions, adoption failure points. Use when @pm has written a spec, before architectural work begins, or when identifying implementation risks. Prerequisite for moving to design/build phase."
```

```yaml
description: "Breaks approved specifications into independently shippable tasks with mapped dependencies. Use after spec is approved by @red-team, before @arch/dev work, or when planning sprint allocation. Outputs task graph with critical path."
```

**Coding Skills (2 examples)**
```yaml
description: "Reviews code for security vulnerabilities (SQL injection, XSS, CSRF, secrets), correctness (edge cases, error handling), performance, and convention drift. Use after any implementation, before merging, during code review, or when auditing for security/best practices. Provides risk report with severity levels."
```

```yaml
description: "Implements backend, frontend, or full-stack features following verification protocol: state goal, verify method, execute, verify results. Use for any development task, API endpoints, migrations, components, or refactoring. Always reports verification proof before handoff to @guard."
```

**Other Categories** (similar pattern)

#### Critical Requirement
**Each description must include:**
- ✅ What it does (active verb)
- ✅ When to invoke (trigger phrases)
- ✅ Estimated output/result

**Examples of BAD descriptions to avoid:**
- ❌ "Reviews code" (missing WHEN)
- ❌ "Use when coding" (too generic)
- ❌ "Designs systems" (missing specific triggers)

---

### Phase 3: Modularize Content → Progressive Disclosure
**Time: 4-5 hours**

For skills with content > 2,500 words, create references:

#### Example: @guard.md (303 lines) → guard/

```
guard/
├── SKILL.md (100 lines - core instructions + checklist overview)
├── references/
│   ├── security-patterns.md (hardcoded secrets, SQL injection, XSS examples)
│   ├── checklists.md (full detailed checklist from current file)
│   ├── severity-levels.md (Critical/High/Medium/Low definitions)
│   └── common-issues.md (code examples: vulnerable vs. safe)
```

SKILL.md should say: "See `references/checklists.md` for the full review checklist."

#### Skills needing modularization:
- `@arch` → Extract patterns, decision frameworks
- `@dev` → Extract dependency loading, verification examples
- `@performance` → Extract query patterns, optimization examples
- `@guard` → Extract security patterns, checklists
- `@frontend-perf` → Extract metrics, optimization techniques
- `@video` → Extract Remotion patterns, component examples
- `@refactoring` → Extract code smell patterns, cleanup techniques

**Guidelines:**
- SKILL.md: 1,000-3,000 words (core instructions + key examples)
- references/*.md: Detailed docs, patterns, checklists
- Link, don't duplicate: "See `references/patterns.md` for 10 common patterns."

---

### Phase 4: Add Handoff Metadata
**Time: 1 hour**

Update metadata to reflect skill dependencies per INDEX.md handoff chain:

```yaml
metadata:
  handoff-from: pm            # Skills that feed into this one
  handoff-to: [red-team, ux]  # Skills this feeds into
  pairs-with: [ux, arch]      # Skills used alongside this one
  category: product
```

**Example for @dev:**
```yaml
metadata:
  handoff-from: [arch, ux]
  handoff-to: [self-review, guard, qa]
  pairs-with: [api-design, data-modeling, performance, frontend-perf, refactoring]
```

**Example for @guard:**
```yaml
metadata:
  handoff-from: [self-review, dev]
  handoff-to: qa
  pairs-with: [api-design, data-modeling, performance, frontend-perf, refactoring, testing]
```

---

### Phase 5: Validation Against PDF Checklist
**Time: 2-3 hours**

For EACH skill, verify:

#### Before Upload
- ☐ Folder named in kebab-case
- ☐ SKILL.md file exists (exact spelling)
- ☐ YAML frontmatter has `---` delimiters
- ☐ `name` field: kebab-case, no spaces, no capitals
- ☐ `description` includes WHAT and WHEN
- ☐ Description < 1024 characters
- ☐ No XML tags (< >) in frontmatter
- ☐ No "claude" or "anthropic" in name
- ☐ No README.md inside skill folder
- ☐ Content logically organized (SKILL.md + references/)
- ☐ All links to references/ work

#### Quick checklist per skill:
```
[ ] @arch — frontmatter ✓, description with triggers ✓, modularized ✓
[ ] @dev — frontmatter ✓, description with triggers ✓, examples → references/ ✓
[ ] @guard — frontmatter ✓, description ✓, checklists → references/checklists.md ✓
... (repeat for all 33)
```

---

### Phase 6: Testing & Validation
**Time: 3-4 hours**

For HIGH-IMPACT skills (those with >1 handoff target):

#### Triggering Tests
Run 3-5 test queries per skill:
```
✅ Should trigger: [obvious use case]
✅ Should trigger: [paraphrased request]
✅ Should trigger: [variant phrasing]
❌ Should NOT trigger: [unrelated request]
❌ Should NOT trigger: [overlapping skill request]
```

**Test set for @guard:**
```
✅ "Review this code for security issues"
✅ "Check for vulnerabilities in my pull request"
✅ "Is there convention drift in this function?"
❌ "Write a function that validates user input" (→ @dev, not @guard)
❌ "Test this code" (→ @qa, not @guard)
```

**Priority order for testing:**
1. **High-Impact** (5+ handoff targets): @dev, @guard, @arch, @pm, @qa
2. **Medium-Impact** (2-4 targets): @api-design, @data-modeling, @self-review, @refactoring
3. **Low-Impact** (0-1 targets): @memory, @confidence-scoring, @video-ai

---

## Detailed Conversion Guide

### Example: Convert @guard to proper skill format

**BEFORE (current state):**
```
coding/guard.md — 303 lines
```

**AFTER (Claude Skills format):**
```
skills/guard/
├── SKILL.md (100 lines)
├── references/
│   ├── security-checklist.md (from current lines 30-120)
│   ├── security-patterns.md (from current lines 219-270)
│   ├── severity-levels.md (from current lines 191-214)
│   ├── code-examples.md (from current lines 220-270)
│   └── drift-detection.md (from current lines 122-151)
```

**SKILL.md content:**
```yaml
---
name: guard
description: "Reviews code for security vulnerabilities (SQL injection, XSS, CSRF, secrets), correctness, performance, and convention drift. Use after implementation, before code review/merge, or when auditing conventions. Provides risk report with severity levels and specific recommendations."
license: MIT
metadata:
  category: coding
  handoff-from: [dev, self-review]
  handoff-to: qa
  pairs-with: [api-design, data-modeling, performance, frontend-perf, refactoring]
  author: Virtual Product Factory
  version: 1.0.0
---

# @guard — Security, Sanity & Convention Drift

**Philosophy:** Simpler is safer. Never trust code you can't explain.

## When to invoke
- After @dev completes implementation
- When reviewing AI-generated or complex code
- Before merging any non-trivial change
- Periodically for convention drift audits (on-demand)

## Quick responsibility summary
- Review code for clarity, correctness, and safety
- Remove abstractions that reduce clarity
- Detect unsanitized input/output or unsafe patterns
- Verify adherence to CONVENTIONS.md
- Flag hardcoded secrets or environment-specific values

## Code review checklist
See `references/security-checklist.md` for the full checklist covering:
- Security (10 items)
- Correctness (8 items)
- Performance (10+ items)
- Code quality (7 items)
- Testing (6 items)
- Error handling (7 items)
- Database (6 items)
- API design (6 items)
- Frontend (7 items)
- Documentation (5 items)

## Severity levels
See `references/severity-levels.md` for Critical/High/Medium/Low definitions.

## Common security issues
See `references/security-patterns.md` for vulnerable vs. safe code examples:
- SQL injection
- XSS (Cross-Site Scripting)
- CSRF (Cross-Site Request Forgery)
- Authentication bypass

## Convention drift detection
When explicitly invoked with "check for drift" or "audit conventions":
See `references/drift-detection.md` for detection patterns and output format.

## Handoffs
- **To `@qa`** → Security/sanity checks pass — ready for testing
- **Back to `@dev`** → Issues found — needs fixes
- **To `@arch`** → If drift suggests architectural changes needed

## Secondary skills
Invoke alongside @guard when reviewing specific concerns:
- **`@api-design`** — reviewing API surface changes
- **`@data-modeling`** — reviewing schema changes
- **`@performance`** — reviewing backend hot paths
- **`@frontend-perf`** — reviewing frontend performance
- **`@refactoring`** — when code quality issues suggest structural changes
```

---

## Skill-by-Skill Conversion Checklist

### PRODUCT OFFICE (4 skills)
- [ ] `@pm` → `skills/pm/`
  - Description: "Translates vague ideas into scoped specs. Asks clarifying questions..."
  - Produces: spec.md
  - Handoff: → @red-team

- [ ] `@red-team` → `skills/red-team/`
  - Description: "Adversarial audit of specs before build. Identifies risks..."
  - Prerequisite: Comes after @pm
  - Handoff: → @ux/@arch

- [ ] `@task-decomposition` → `skills/task-decomposition/`
  - Description: "Breaks specs into independently shippable tasks..."
  - Handoff: → dev team

- [ ] `@decision-framework` → `skills/decision-framework/`
  - Description: "Evaluates competing options using explicit criteria..."
  - Output: ADR (Architecture Decision Record)

### DESIGN STUDIO (2 skills)
- [ ] `@ux` → `skills/ux/`
  - Description: "Produces user flows, component states, interaction specs..."
  - Handoff: → @arch

- [ ] `@accessibility` → `skills/accessibility/`
  - Description: "Enforces semantic HTML, ARIA, keyboard nav, WCAG compliance..."
  - Pairs-with: Any frontend work

### ENGINEERING HUB (13 skills)
- [ ] `@arch` → `skills/arch/` ⭐ High priority
  - Description: "Designs system structure, data flows, boundaries..."
  - Handoff: → @dev
  - Modularize: patterns.md, decision-frameworks.md

- [ ] `@dev` → `skills/dev/` ⭐ High priority
  - Description: "Implements backend/frontend/fullstack. Follows verification protocol..."
  - Pairs-with: [api-design, data-modeling, performance, frontend-perf, refactoring]
  - Handoff: → @self-review
  - Modularize: verification-examples.md, patterns.md, dependency-loading.md

- [ ] `@api-design` → `skills/api-design/`
  - Description: "Designs API endpoints, request/response contracts, versioning..."
  - Pairs-with: @dev

- [ ] `@data-modeling` → `skills/data-modeling/`
  - Description: "Designs schemas, relationships, migration strategies..."
  - Pairs-with: @dev

- [ ] `@git-workflow` → `skills/git-workflow/`
  - Description: "Enforces commit format, changelog discipline, file organization..."

- [ ] `@guard` → `skills/guard/` ⭐ High priority
  - (See example conversion above)
  - Handoff: → @qa
  - Modularize: checklists.md, security-patterns.md, severity-levels.md

- [ ] `@qa` → `skills/qa/` ⭐ High priority
  - Description: "Tests edge cases, regressions, coverage gaps..."
  - Handoff: → deployment/merge

- [ ] `@self-review` → `skills/self-review/`
  - Description: "Pre-handoff quality check before @guard review..."
  - Handoff: → @guard

- [ ] `@debugging` → `skills/debugging/`
  - Description: "Investigates bugs with root cause analysis..."
  - Handoff: → @dev (for fixes)

- [ ] `@refactoring` → `skills/refactoring/`
  - Description: "Structural cleanup without behavior change..."
  - Pairs-with: @dev
  - Modularize: patterns.md, techniques.md

- [ ] `@performance` → `skills/performance/`
  - Description: "Identifies slow queries, caching opportunities, backend bottlenecks..."
  - Pairs-with: @dev
  - Modularize: patterns.md, optimization-techniques.md

- [ ] `@frontend-perf` → `skills/frontend-perf/`
  - Description: "Improves Web Vitals, bundle size, rendering performance..."
  - Pairs-with: @dev
  - Modularize: metrics.md, optimization-techniques.md

- [ ] `@testing` → `skills/testing/`
  - Description: "Defines testing strategy, TDD approach, mocking patterns..."

### GROWTH STUDIO (5 skills)
- [ ] `@writer` → `skills/writer/`
  - Description: "Articles, newsletters, social posts, email campaigns..."

- [ ] `@seo` → `skills/seo/`
  - Description: "Meta tags, structured data, technical SEO, crawlability..."

- [ ] `@perf` (marketing) → `skills/marketing-perf/` ⚠️ Rename to avoid collision with `@performance`
  - Description: "Ad copy, landing pages, UTM tracking, A/B test design..."

- [ ] `@video-ai` → `skills/video-ai/`
  - Description: "AI video generation using Runway, Kling, fal.ai..."

- [ ] `@video` → `skills/video/`
  - Description: "Remotion-specific video production (code-driven video)..."
  - Modularize: patterns.md, component-examples.md

### INFRA LAB (3 skills)
- [ ] `@deployment` → `skills/deployment/`
  - Description: "Deployment principles—rollout strategies, environment parity, rollback..."

- [ ] `@cicd` → `skills/cicd/`
  - Description: "GitHub Actions CI/CD setup, pipeline configuration, triggers..."

- [ ] `@cloud` → `skills/cloud/`
  - Description: "Infrastructure architecture, IaC, cloud security posture..."

### META OFFICE (4 skills)
- [ ] `@memory` → `skills/memory/`
  - Description: "Persists agent state, decisions, execution plans across sessions..."

- [ ] `@confidence-scoring` → `skills/confidence-scoring/`
  - Description: "Assesses confidence level and risk before low-certainty tasks..."

- [ ] `@context-strategy` → `skills/context-strategy/`
  - Description: "Manages context window—decides what to load/release..."

- [ ] `@error-recovery` → `skills/error-recovery/`
  - Description: "Handles test/build/deployment failures autonomously..."

### BRAND OFFICE (1 skill)
- [ ] `@brand` → `skills/brand/`
  - Description: "Brand guidelines, tone, visual identity, messaging standards..."

---

## Dependencies & Handoff Chain

```
@pm ──→ @red-team ──┬──→ @ux ──┐
                    └──→ @arch ┤
                                ↓
                              @dev ────┬──→ @self-review ──→ @guard ──→ @qa
                                       ├──→ @api-design
                                       ├──→ @data-modeling
                                       ├──→ @performance
                                       ├──→ @frontend-perf
                                       └──→ @refactoring

Standalone:
@debugging ──→ @dev (for fixes)
@confidence-scoring (any time)
@memory (multi-day tasks)
@error-recovery (on failures)
@testing (TDD cycle)
@deployment, @cicd, @cloud (ops)
@writer, @seo, @marketing-perf, @video, @video-ai (marketing)
```

---

## Success Metrics (PDF Checklist)

✅ **Quantitative:**
- All 33 skills have proper SKILL.md + YAML frontmatter
- 100% have descriptions with WHAT + WHEN
- 0 XML tags (< >) in any skill
- SKILL.md files < 5,000 words each
- Descriptions < 1,024 characters each

✅ **Qualitative:**
- Each skill triggers on obvious use cases (90%+)
- No under-triggering (users don't manually invoke skills that should auto-load)
- No over-triggering (skills don't load for unrelated queries)
- Handoff chain is clear (users know what comes next)

---

## Implementation Schedule

| Phase | Task | Time | Priority |
|-------|------|------|----------|
| 1 | Create `skills/` folder structure | 1-2h | P0 |
| 2 | Write YAML frontmatter (33 skills) | 3-4h | P0 |
| 3 | Modularize long skills → references/ | 4-5h | P1 |
| 4 | Add handoff metadata | 1h | P1 |
| 5 | Validation checklist pass | 2-3h | P1 |
| 6 | Test high-impact skills (5 skills) | 3-4h | P2 |
| **Total** | | **14-19h** | |

**Recommended approach:**
1. **Day 1**: Phase 1-2 (structure + frontmatter)
2. **Day 2**: Phase 3-4 (modularization + metadata)
3. **Day 3**: Phase 5-6 (validation + testing)

---

## Tools & Commands

```bash
# Verify structure
find skills/ -name "SKILL.md" | wc -l  # Should be 33

# Check for XML tags in any file
grep -r "<\|>" skills/ || echo "✅ No XML tags found"

# Verify kebab-case naming
ls -1 skills/ | grep -E "[A-Z_]" && echo "❌ Non-kebab-case found" || echo "✅ All kebab-case"

# Check description lengths
for dir in skills/*/; do
  lines=$(grep "^description:" "$dir/SKILL.md" | wc -c)
  if [ $lines -gt 1024 ]; then
    echo "❌ $(basename $dir): description too long ($lines chars)"
  fi
done
```

---

## Next Steps

1. **Approve this plan** — Any changes needed?
2. **Start Phase 1** — Create folder structure
3. **Track progress** — Use checklist above to verify each skill
4. **Test incrementally** — After each phase, spot-check 2-3 skills

Ready to begin?
