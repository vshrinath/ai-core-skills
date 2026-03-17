---
name: frontend-perf
description: Optimizes client-side performance for fast, responsive user experiences. Focuses on Core Web Vitals, bundle size, image optimization, and JavaScript performance. WHEN to use it - optimizing page load times, Core Web Vitals, bundle sizes, or client-side rendering performance.
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

# @frontend-perf — Frontend Performance Optimization

**Role**: Optimize client-side performance for fast, responsive user experiences

**Secondary skills**: `@performance` (backend performance), `@dev` (implementation), `@qa` (performance testing)

---

## Core Principles

1. **Measure first, optimize second** — Use real metrics, not assumptions
2. **Optimize for perceived performance** — What users feel matters more than raw numbers
3. **Progressive enhancement** — Core content works without JavaScript
4. **Budget-driven development** — Set performance budgets and enforce them
5. **User-centric metrics** — Focus on Core Web Vitals (LCP, FID/INP, CLS)

---

## Performance Budgets

Define measurable targets before building:
- LCP: < 2.5s
- INP: < 100ms
- CLS: < 0.1
- Total blocking time: < 300ms
- JavaScript bundle (initial load): < 200KB gzipped
- Lighthouse performance score: > 90

Enforce budgets in CI with Lighthouse CI.

---

## Monitoring & Measurement

**Lab** (Lighthouse, WebPageTest): synthetic, reproducible, run in CI. Good for catching regressions.

**Field** (Real User Monitoring): use the Web Vitals library to capture CWV from real sessions.

Use both: lab for prevention, field for diagnosis.

---

## Detailed Reference

Load `references/details.md` for:
- Core Web Vitals: LCP, FID/INP, CLS — causes and optimization strategies
- Bundle size: analyzer tools, tree shaking, code splitting, lighter alternatives
- Image optimization: formats, responsive images, lazy loading
- JavaScript: main thread work, Web Workers, re-render optimization
- CSS: critical CSS, unused CSS removal, runtime CSS-in-JS tradeoffs
- Caching: HTTP caching, service workers, client-side data caching
- Third-party scripts: async/defer, facade pattern
- Framework-specific notes (Next.js examples)

---

## Performance Checklist

Before marking frontend performance work complete:

- [ ] Core Web Vitals meet targets (LCP <2.5s, INP <100ms, CLS <0.1)
- [ ] Images: modern format, explicit dimensions, lazy loaded (except LCP image)
- [ ] JavaScript bundle analyzed — no unexpectedly large dependencies
- [ ] Code splitting applied to routes and heavy components
- [ ] Non-critical scripts loaded asynchronously
- [ ] Critical CSS inlined; non-critical CSS deferred
- [ ] Performance budgets defined and enforced in CI
- [ ] Real user monitoring in place
- [ ] Tested on real mobile devices and throttled networks (3G)
- [ ] Cache headers correct for static assets
