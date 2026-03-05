# Changelog

All notable changes to **The Virtual Product Factory** will be documented in this file.

---

## [2026-03-05] — Red-Team Audit + Structural Hardening

**Branch**: `master`

### What changed
- Added `product/red-team.md` — new adversarial spec audit skill with 5-question protocol and PASS / REVISE / ABANDON verdict
- Added Technical Feasibility Check to `coding/arch.md` — step zero before any design work, cross-referencing spec against project stack
- Added `## Startup Protocol` to `AGENTS.md` — defines exactly two files loaded on session start; skill files load on-demand only. Includes minimum working set table.
- Added `@red-team` to `AGENTS.md` Handoff Triggers table with explicit document gate: audit file must exist before handoff to `@arch`
- `AGENTS.md` workflow chain updated: `@pm → @red-team → @ux → @arch → @dev → @guard → @qa`
- Rewrote `INDEX.md` — dropped Transferability column, removed duplicate Quick Reference and Usage Examples sections, added Produces column, updated Handoff Chain to include `@red-team`
- Added `## Quick Start` section to `README.md` — six copy-paste prompts above the departmental diagram
- Added `## Artifact Registry` to `README.md` — maps each skill to its named output artifact
- Declared `INDEX.md` as canonical skill inventory in both `README.md` and `AGENTS.md`
- Trimmed `CONVENTIONS.md` from 459 lines to ~130 — removed boilerplate code examples, removed stale `.kiro/skills/` references, kept only actionable placeholder structure
- Removed hardcoded skill list from `setup.sh` echo block

### Why
Red-team audit of the VPF's own documentation revealed four structural weaknesses: no defined loading contract for agents, no quick-start for new users, taxonomy drift across multiple files, and documentation claiming autonomous routing without evidence. This commit closes the first three findings.

### Files touched
- `product/red-team.md` — new file
- `coding/arch.md` — Technical Feasibility Check added
- `AGENTS.md` — Startup Protocol, updated workflow chain, Handoff Triggers table, @red-team in skills listing
- `INDEX.md` — full rewrite
- `README.md` — Quick Start section, Artifact Registry, canonical taxonomy note, @red-team in Skills Directory and Handoff Protocol
- `CONVENTIONS.md` — trimmed and cleaned
- `setup.sh` — removed hardcoded skill list
