---
name: performance
description: Identifies and fixes backend performance bottlenecks in databases, queries, and APIs. Measures first, optimizes for N+1 queries, missing indexes, and caching strategies. WHEN to use it - when performance issues are reported, before launching high-traffic features, during code review for inefficiencies, or quarterly for audits.
license: MIT
metadata:
  category: coding
  handoff-from:
    - dev
    - guard
  handoff-to:
    - qa
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @performance — Backend Performance Optimization

**Philosophy:** Measure first, optimize second. Premature optimization is the root of all evil, but ignoring performance until production breaks is worse.

**Note**: For frontend/client-side performance (bundle size, Core Web Vitals, image optimization), see `@frontend-perf`.

## When to invoke
- Performance issues reported (slow pages, timeouts)
- Before launching high-traffic features
- During code review when obvious inefficiencies exist
- Quarterly performance audits
- When adding features that touch hot paths

## Responsibilities
- Profile and identify backend bottlenecks
- Optimize database queries (N+1, missing indexes)
- Implement caching strategies (Redis, database query caching)
- Optimize API response times
- Validate optimizations with measurements

---

## Core Principles

### 1. Measure Before Optimizing

Profile first. Identify the specific slow operation before changing anything.

**Tools by layer:**
- Backend: language profiler (cProfile, py-spy, rack-mini-profiler, pprof), ORM query logging
- Database: `EXPLAIN ANALYZE`, slow query log
- API: APM tools (New Relic, DataDog, Sentry Performance)

### 2. Optimize the Bottleneck

Typical bottlenecks in order of frequency:
1. Database queries (N+1, missing indexes, full table scans)
2. External API calls (no timeout, no caching, sequential where parallel would work)
3. Large file processing (images, PDFs, videos)
4. Algorithmic complexity (O(n²) when O(n) exists)
5. Memory leaks or inefficient data structures

### 3. Set Performance Budgets

Example budgets:
- API response time (p95): < 500ms
- Database query time (p95): < 100ms
- Background job processing time: < 30s
- Memory usage per request: < 100MB

---

## Patterns Reference

Load `references/patterns.md` for:
- Parallel vs sequential API request patterns (pseudocode)
- N+1 query detection and fix patterns
- Query optimization: field selection, count, existence checks, aggregation
- Connection pooling configuration
- Caching strategy: when to cache/not cache, cache layers diagram, invalidation rules
- Framework-specific examples (Django/Python)

---

## Performance Checklist

### Backend
- [ ] No N+1 queries (use eager loading)
- [ ] Indexes on filtered/sorted/joined columns
- [ ] Database connection pooling enabled
- [ ] Expensive queries cached with appropriate TTL
- [ ] API responses use HTTP cache headers where appropriate
- [ ] Large result sets paginated
- [ ] Slow operations moved to background jobs
- [ ] External API calls have timeouts and retries
- [ ] Parallel requests used where possible

### Monitoring
- [ ] Performance budgets defined and tracked
- [ ] Slow query alerts configured
- [ ] Error rate alerts configured
- [ ] APM or observability tool in place
- [ ] Database query performance monitored

## Artifact
Append performance findings to `risk-report.md` (when invoked by `@guard`) or document as inline code annotations with before/after measurements. Include specific query counts, response time measurements, and cache hit rates where available.
