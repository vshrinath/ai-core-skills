# AI Core Skills - Index

**18 highly transferable skills (85%+ portability across projects)**

---

## Quick Reference

### Standard workflow (full feature)
```
@pm → @ux → @arch → @dev → @guard → @qa → @ops
```

### Small coding fix
```
@dev → @guard
```

### Content / marketing
```
@writer → @seo
```

### Bug investigation
```
@debugging → @dev → @guard
```

### High-stakes decision
```
@decision-framework → @arch → @dev
```

---

## All Skills

### Product & Planning

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@pm` | `product/pm.md` | Feature scoping, requirements, acceptance criteria | 100% |
| `@task-decomposition` | `product/task-decomposition.md` | Breaking features into small, testable tasks with dependencies | 100% |
| `@decision-framework` | `product/decision-framework.md` | Architecture decisions, build vs. buy, technical debt, any high-stakes decision with unclear tradeoffs | 100% |

### Meta (Autonomous Operation)

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@confidence-scoring` | `meta/confidence-scoring.md` | Assessing confidence level, determining when to ask for help | 100% |
| `@context-strategy` | `meta/context-strategy.md` | Managing limited context window, efficient file navigation | 100% |
| `@error-recovery` | `meta/error-recovery.md` | Handling test/build/deployment failures autonomously | 100% |

### Coding

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@guard` | `coding/guard.md` | Code review, security audit, convention drift check | 95% |
| `@qa` | `coding/qa.md` | Testing, edge cases, regression verification | 95% |
| `@self-review` | `coding/self-review.md` | Pre-handoff quality check before requesting code review | 95% |
| `@debugging` | `coding/debugging.md` | Bug investigation, intermittent failures, root cause analysis | 95% |
| `@refactoring` | `coding/refactoring.md` | Code smells, safe structural cleanup, tech debt reduction | 95% |
| `@api-design` | `coding/api-design.md` | Designing or reviewing API endpoints and contracts | 90% |

### Marketing

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@video-ai` | `marketing/video-ai.md` | AI video generation with cinematography knowledge (Runway, Pika, Luma, Kling, fal.ai) | 100% |
| `@writer` | `marketing/writer.md` | Articles, newsletters, social posts, email campaigns | 95% |
| `@seo` | `marketing/seo.md` | Meta tags, structured data, technical SEO | 90% |
| `@perf` | `marketing/perf.md` | Ad copy, landing pages, UTM tracking, A/B tests | 85% |

### Design

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@ux` | `design/ux.md` | User flows, component states, accessibility, form design | 90% |

### Operations

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| — | `ops/deployment-practices.md` | Universal deployment principles (any stack) | 100% |
| — | `ops/cicd-pipelines.md` | GitHub Actions CI/CD setup and configuration | 95% |

---

## Secondary Skills — When to Pair

Secondary skills are invoked *alongside* a primary skill, not instead of one.

| If you're doing... | Also invoke |
|--------------------|-------------|
| Implementing features that touch the API | `@api-design` |
| Completing implementation before handoff | `@self-review` |
| Reviewing API surface changes | `@api-design` |
| Investigating a bug | `@debugging` |
| Cleaning up code as part of a task | `@refactoring` |
| Planning work breakdown | `@task-decomposition` |
| High-stakes decisions with unclear tradeoffs | `@decision-framework` |
| Assessing task difficulty | `@confidence-scoring` |
| Managing large codebase navigation | `@context-strategy` |
| Handling failures or errors | `@error-recovery` |

---

## Handoff Chain

```
@pm          →  Scoped requirements with acceptance criteria
  @ux        →  User flows and component specs
    @arch    →  System design and implementation plan
      @dev   →  Working implementation
        @self-review → Pre-handoff quality check
          @guard →  Code review: security, correctness, conventions
            @qa  →  Testing: edge cases, coverage, regressions
              @ops →  Deployment: checklist, environment, monitoring
```

**Skip any step that doesn't apply.** A bug fix doesn't need `@pm` or `@ux`. A content task doesn't need `@arch` or `@ops`.

---

## Autonomous Workflow

For fully autonomous AI development:

```
1. @task-decomposition  →  Break feature into small, testable tasks
2. @confidence-scoring  →  Assess confidence for each task; ask before low-confidence ones
3. @context-strategy    →  Load only what's needed for the current task
4. @dev                 →  Implement
5. @self-review         →  Check own work before handoff
6. @guard               →  Security/convention review
7. @qa                  →  Test
8. @ops                 →  Deploy
```

**`@error-recovery` is not a sequential step** — invoke it at any point when a test, build, or deployment fails.

**`@confidence-scoring` applies per task**, not just once at the start. Re-assess before each task in the decomposed list.

---

## Excluded Skills (Project-Specific)

These skills were **not included** in the golden set due to low transferability:

| Skill | Transferability | Why Excluded |
|-------|----------------|--------------|
| `@arch` | 70% | Has Django/Wagtail examples |
| `@dev` | 60% | Has Django/Wagtail references |
| `@data-modeling` | 70% | Has Django ORM examples |
| `@performance` | 70% | Has Django examples |
| `@frontend-perf` | 80% | Has Next.js examples |
| `@video` (Remotion) | 0% | Remotion-specific only |
| `@ops` | 85% | Has some Django references |
| `deploy-aws` | 50% | AWS-specific |
| `deploy-python-django` | 0% | Django-only |

**For these skills:** Copy to project and customize examples for your stack.

---

## Version History

- **v1.0.0** (2026-02-27) - Initial golden set with 18 skills
- Extracted from production FoundingFuel project
- Tested across Django/Wagtail + Next.js stack
- 85%+ transferability threshold

---

## Usage Examples

### Loading Skills in Different AI Assistants

**Claude/Cursor:**
```
Load skills: @pm, @ux, @dev, @guard, @qa

Task: Add user authentication to the dashboard
```

**GitHub Copilot Chat:**
```
#file:skills/product/pm.md
#file:skills/coding/dev.md
#file:skills/coding/guard.md

Help me scope and implement user authentication
```

**Windsurf:**
```
@pm @dev @guard

I need to add user authentication. Help me scope it first, then implement securely.
```

### Project Setup

```bash
# New project setup
git submodule add https://github.com/vshrinath/ai-core-skills.git skills
git submodule update --init

# Load core skills for any project
echo "Skills available: @pm @task-decomposition @decision-framework @guard @qa @debugging @video-ai @writer @seo @ux"
```