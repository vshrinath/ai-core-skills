# Changelog

All notable changes to this project will be documented in this file.

---

## [2026-02-28] — Simplify AGENTS.md to 13 universal principles, move practices to skills

**Commit**: `pending` on branch `master`

### What changed
- Reduced AGENTS.md from 18 rules to 13 universal principles
- Created new `@git-workflow` skill covering commit messages, changelog maintenance, and file organization
- Merged old Rule 8 (Don't Guess) and Rule 9 (Autonomous Work) into unified Rule 8
- Removed Rules 14-18 (moved to skills or redundant):
  - Rule 14 (Commit Messages) → moved to @git-workflow skill
  - Rule 15 (Changelog) → moved to @git-workflow skill
  - Rule 16 (File Organization) → moved to @git-workflow skill
  - Rule 17 (Context Discipline) → redundant with @context-strategy skill
  - Rule 18 (Goal-Driven) → covered by @pm and @task-decomposition skills
- Updated INDEX.md and README.md to include @git-workflow
- Total skills now: 25 (24 transferable + 1 Remotion-specific)

### Why
AGENTS.md had overlapping rules and mixed universal principles with specific practices. Separated concerns: AGENTS.md now contains only universal principles that apply to ALL work, while specific practices (git workflow, context management, goal setting) live in skills where they can be detailed and context-aware. This makes the rules clearer, less redundant, and easier to follow.

### Files touched
- `AGENTS.md` — Reduced from 18 to 13 rules, merged Rule 8+9, removed Rules 14-18
- `coding/git-workflow.md` — Created new skill for git workflow practices
- `.kiro/skills/coding/git-workflow.md` — Copied for Kiro integration
- `INDEX.md` — Added @git-workflow skill, updated count to 25 skills
- `README.md` — Added @git-workflow to coding skills list

---

## [2026-02-28] — Move Rule 19 to Rule 9 (reordering)

**Commit**: `pending` on branch `master`

### What changed
- Moved "Autonomous Work Requires Complete Specifications" from Rule 19 to Rule 9
- Renumbered all subsequent rules (old 9-18 became 10-19)
- Positioned immediately after Rule 8 (Don't Guess at Requirements) since they're closely related

### Why
Rule 9 (Autonomous Work) is a foundational principle for AI agents working independently, not a late-stage consideration. It belongs early in the rules, right after "Don't Guess at Requirements" which it extends and elaborates on. This makes the rule order more logical: basic principles first, then specific practices.

### Files touched
- `AGENTS.md` — Moved Rule 19 to Rule 9, renumbered Rules 9-18 to 10-19

---

## [2026-02-28] — Add Rule 19: Autonomous Work Requires Complete Specifications

**Commit**: `pending` on branch `master`

### What changed
- Added Rule 19 to AGENTS.md for AI agents working autonomously
- Reframed specification engineering primitives as questions agents should ask humans
- Emphasizes asking clarifying questions upfront rather than guessing or getting stuck mid-work
- Integrated with existing rules (Rule 8: Don't Guess, Rule 18: Goal-Driven Execution)
- Linked to skills (@pm, @task-decomposition, @confidence-scoring)

### Why
The previous version incorrectly framed the rule as instructions for humans on how to write specifications. This version correctly frames it as guidance for AI agents on what information they need before starting autonomous work, and what questions to ask when that information is missing. The rule now emphasizes "ask clarifying questions until you have complete specifications" rather than "humans should provide complete specifications."

### Files touched
- `AGENTS.md` — Rewrote Rule 19 from agent perspective (what to ask, not what to expect)

---

## [2026-02-28] — v2.0.0 - Major release with 5 new skills and brand system

**Commit**: `66a41e4` on branch `master`

### What changed
- Added 5 new coding skills: @arch, @dev, @data-modeling, @performance, @frontend-performance
- Added @video skill for Remotion-specific video production (React/TypeScript)
- Created brand system with brand-template.md and assets folder structure
- Simplified setup.sh to use symlinks instead of duplicating content (single source of truth: AGENTS.md)
- Updated .gitignore to exclude all generated AI tool config files
- Added brand/brand.md references to all marketing skills (@video-ai, @video, @writer, @seo, @perf)
- Cleaned up obsolete config files (.ai-config/, old .cursor/rules.md, .windsurf/rules.md, etc.)
- Updated INDEX.md and README.md to reflect 24 total skills (23 transferable + 1 Remotion-specific)

### Why
Expanded the golden skill set from 18 to 24 skills by adding highly-requested architecture, implementation, and performance skills that were previously excluded due to framework-specific examples. Cleaned up those skills to be 85%+ transferable. Added brand system to support marketing skills with consistent voice and visual identity. Simplified setup to use symlinks for easier maintenance.

### Files touched
- `AGENTS.md` — Updated skills list to include new skills
- `INDEX.md` — Added 6 new skills, updated version to v2.0.0, removed "Excluded Skills" section
- `README.md` — Added brand system documentation, updated skill counts, removed scripts section
- `setup.sh` — Complete rewrite to use symlinks, simplified from ~500 to ~250 lines
- `.gitignore` — Added generated AI tool config files
- `coding/arch.md` — Added (architectural decisions and system design)
- `coding/dev.md` — Added (implementation guide)
- `coding/data-modeling.md` — Added (database schema and migrations)
- `coding/performance.md` — Added (backend performance optimization)
- `coding/frontend-performance.md` — Added (frontend performance)
- `marketing/video.md` — Added (Remotion-specific video production)
- `marketing/video-ai.md` — Added brand reference
- `brand/brand-template.md` — Added (customizable brand guide template)
- `brand/README.md` — Added (brand system documentation)
- `brand/assets/.gitkeep` — Added (placeholder for brand assets)
- `.kiro/skills/*` — Added all skills for Kiro integration
- Deleted: `.ai-config/`, old config files with content, `scripts/` folder
