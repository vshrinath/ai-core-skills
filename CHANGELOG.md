# Changelog

All notable changes to this project will be documented in this file.

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
