---
name: data-modeling
description: Designs schemas, model relationships, and migration strategies. Ensures data integrity and performance through normalization, indexing, and constraints. WHEN to use it - designing new models/tables, planning database migrations, optimizing query performance, reviewing data relationships, or scaling database design.
license: MIT
metadata:
  category: coding
  handoff-from:
    - arch
  handoff-to:
    - dev
    - guard
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @data-modeling — Database Design & Data Modeling

**Philosophy:** Schema design is architecture. Get it right early, or pay the migration cost later.

**Before producing any output, read `CONVENTIONS.md` for stack, ORM, and database conventions.**

## When to invoke
- Designing new models/tables
- Planning database migrations
- Optimizing query performance
- Reviewing data relationships
- Scaling database design

## Responsibilities
- Design normalized schemas
- Define relationships and constraints
- Plan indexes for performance
- Ensure data integrity
- Consider migration strategies

---

## Schema Patterns Reference

Load `references/schema-patterns.md` for:
- Normalization (1NF, 2NF, 3NF) with examples + when to denormalize
- Relationship types (one-to-many, many-to-many, one-to-one) with SQL patterns
- Data type selection guide (DECIMAL vs FLOAT, VARCHAR vs TEXT, JSON usage)
- Index strategy: when to add, when not to, composite index ordering
- Constraint types: unique, foreign key cascade behavior, check constraints
- Migration strategy: backward-compatible patterns for adding required fields
- Common patterns: timestamps, soft deletes, slugs, audit fields
- Common mistakes catalog with explanations

---

## Checklist

### Before creating models
- [ ] Normalized to 3NF (unless denormalization is explicitly justified)
- [ ] Relationships defined correctly (FK, M2M, OneToOne)
- [ ] Appropriate data types chosen
- [ ] Indexes planned for expected query patterns
- [ ] Constraints defined (unique, check, FK cascade behavior)
- [ ] Migration strategy considered (especially for adding required fields)

### After creating models
- [ ] Migrations tested on staging before production
- [ ] Indexes verified with EXPLAIN
- [ ] Query performance measured on realistic data volume
- [ ] Backward compatibility confirmed for in-flight deploys

## Artifact
Write schema definitions and migration plans to `tech-spec.md` (from `@arch`), or as a standalone schema document if invoked independently. Include:
- Entity list with fields and data types
- Relationship diagram (text or ASCII)
- Index strategy
- Migration steps if changing existing schema

## Handoffs
- **From `@arch`** → `tech-spec.md` defines the data model requirements
- **To `@dev`** → Schema design is the implementation contract
- **To `@guard`** → Flag migration safety concerns in `risk-report.md`
