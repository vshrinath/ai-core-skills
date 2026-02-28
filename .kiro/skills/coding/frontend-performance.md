# @frontend-perf — Frontend Performance Optimization

**Role**: Optimize client-side performance for fast, responsive user experiences

**When to use**: When optimizing page load times, Core Web Vitals, bundle sizes, or client-side rendering performance

**Secondary skills**: `@performance` (backend performance), `@dev` (implementation), `@qa` (performance testing)

---

## Core Principles

1. **Measure first, optimize second** — Use real metrics, not assumptions
2. **Optimize for perceived performance** — What users feel matters more than raw numbers
3. **Progressive enhancement** — Core content works without JavaScript
4. **Budget-driven development** — Set performance budgets and enforce them
5. **User-centric metrics** — Focus on Core Web Vitals (LCP, FID/INP, CLS)

---

## Core Web Vitals

### Largest Contentful Paint (LCP) — Target: <2.5s

**What it measures**: Time until the largest content element is visible

**Common causes of poor LCP**:
- Slow server response times
- Render-blocking JavaScript/CSS
- Slow resource load times (images, fonts)
- Client-side rendering delays

**Optimization strategies**:
- Preload critical resources (hero images, above-fold fonts)
- Use optimized image formats (AVIF/WebP with fallbacks)
- Inline critical CSS; defer non-critical CSS
- Serve images at the correct size for the viewport
- Use `priority` / `fetchpriority="high"` on the LCP image

### First Input Delay (FID) / Interaction to Next Paint (INP) — Target: <100ms

**What it measures**: Time from user interaction to browser response

**Common causes of poor FID/INP**:
- Heavy JavaScript execution blocking the main thread
- Large bundles parsing/compiling at load
- Long-running event handlers

**Optimization strategies**:
- Code-split: load only what the current view needs
- Defer non-critical scripts (analytics, ads)
- Break up long-running tasks; yield to the browser between chunks
- Move heavy computation to Web Workers

### Cumulative Layout Shift (CLS) — Target: <0.1

**What it measures**: Visual stability — how much content shifts unexpectedly

**Common causes of poor CLS**:
- Images without explicit width/height
- Ads or embeds without reserved space
- Web fonts causing FOIT/FOUT layout shifts
- Dynamic content injected above existing content

**Optimization strategies**:
- Always set explicit width and height on images
- Reserve space for ads/embeds with min-height
- Use `font-display: swap` and preload critical fonts
- Use CSS `contain: layout` for dynamic sections

---

## Bundle Size Optimization

### Analyze before optimizing

Run a bundle analyzer to see what's actually large. For webpack-based projects: `@next/bundle-analyzer`, `webpack-bundle-analyzer`. For other bundlers: Rollup Visualizer, Vite's `rollup-plugin-visualizer`. Check package size before adding a dependency — tools like `bundlephobia` give size + tree-shakability at a glance.

### Core strategies

**Tree shaking — eliminate dead code**

Import only what you use. Prefer named imports from ES modules over default imports of entire libraries. When a utility can be written in a few lines (debounce, clamp, format), prefer that over importing a large library for one function.

**Code splitting by route**

Each route/page should only load the JavaScript it needs. Load heavy components dynamically so they don't block initial render.

**Lazy load below-the-fold content**

Components that aren't visible on initial load don't need to be in the critical bundle. Wrap them in lazy/dynamic imports with a loading fallback.

**Choose lighter alternatives**

Before installing a dependency, check its size and whether a native API covers the use case. Common swaps: `date-fns` or `dayjs` over `moment`, native `fetch` over `axios`, native array methods over utility libraries.

---

## Image Optimization

### Principles

- Serve images in modern formats (AVIF → WebP → JPEG/PNG fallback)
- Always specify width and height to prevent layout shift
- Use responsive images (`srcset` + `sizes`) so mobile devices don't download desktop-sized images
- Lazy load images below the fold; eager-load the LCP image with high priority
- Compress images at the right quality level — 80–85% is usually indistinguishable from lossless

### Lazy loading

Use the native `loading="lazy"` attribute on `<img>` for below-fold images. Use `loading="eager"` (or omit the attribute) on the LCP image. For more control, IntersectionObserver lets you trigger loading when an element enters the viewport.

---

## JavaScript Performance

### Minimize main thread work

The main thread handles user input, rendering, and JavaScript execution. Long tasks (>50ms) block interactivity. Strategies:
- Move heavy computation to Web Workers
- Break large loops into chunks and yield between them (`setTimeout(0)` or `scheduler.yield()`)
- Debounce expensive event handlers (resize, scroll, input)
- Throttle operations that fire continuously (scroll position tracking)

### Optimize re-renders (component frameworks)

Unnecessary re-renders waste main thread time. General principles:
- Memoize expensive derived values so they only recalculate when inputs change
- Stabilize function references passed as props so child components don't re-render when the parent does
- Use shallow equality for re-render comparison where possible
- Virtualize long lists — render only the items visible in the viewport

---

## CSS Performance

### Critical CSS

Inline the CSS needed to render above-the-fold content in the `<head>`; load the rest asynchronously. This prevents a render-blocking round trip for the stylesheet.

### Remove unused CSS

Use a tool that analyzes your templates and strips CSS classes that are never referenced. Most CSS frameworks with JIT compilation (Tailwind, etc.) do this automatically when configured with the right content paths.

### Avoid runtime CSS-in-JS on critical paths

Libraries that generate styles at runtime add JavaScript execution cost on every render. Prefer zero-runtime alternatives (vanilla-extract, linaria) or CSS Modules for performance-critical components.

---

## Caching Strategies

### HTTP caching

Static assets (JS bundles, images, fonts) with content-hashed filenames can be cached indefinitely (`Cache-Control: public, max-age=31536000, immutable`). HTML and API responses need shorter TTLs or `no-cache` with revalidation.

### Service worker caching

A service worker can implement cache-first for static assets (serve from cache, update in background) and network-first for API data (try network, fall back to cache). Use only when you have a clear offline or performance requirement — service workers add complexity.

### Client-side data caching

Use a data-fetching library (SWR, React Query, Apollo) that handles deduplication, background revalidation, and stale-while-revalidate semantics. Don't reinvent this with raw `useEffect` + `useState`.

---

## Third-Party Scripts

Third-party scripts (analytics, ads, chat widgets, A/B testing) are a common source of performance regressions because they're outside your control.

- Load non-critical scripts with `async` or `defer` to avoid blocking parsing
- Use `lazyOnload` or equivalent strategy for analytics and ads
- Use the **facade pattern** for heavy embeds (YouTube, maps, chat): show a lightweight screenshot or thumbnail, load the real embed only when the user clicks

---

## Performance Budgets

Define measurable targets before building. Example budget:
- LCP: < 2.5s
- INP: < 100ms
- CLS: < 0.1
- Total blocking time: < 300ms
- JavaScript bundle (initial load): < 200KB gzipped
- Lighthouse performance score: > 90

Enforce budgets in CI with Lighthouse CI so regressions are caught before they reach production.

---

## Monitoring & Measurement

### Lab vs field data

**Lab** (Lighthouse, WebPageTest): synthetic, reproducible, run in CI. Good for catching regressions. Not representative of real users.

**Field** (Real User Monitoring): actual user experience. Use the Web Vitals library to capture CLS/FID/LCP/TTFB from real sessions and send to your analytics or APM tool.

Use both: lab for prevention, field for diagnosis.

### Profiling workflow

1. Identify the metric that's failing (LCP, INP, bundle size) from field data or Lighthouse
2. Use browser DevTools (Performance tab, Network tab) to reproduce and locate the bottleneck
3. Check Coverage tab for unused CSS/JS
4. Check Network tab for render-blocking resources and unoptimized images
5. Measure before and after any change

---

## Progressive Web App (PWA) Implementation

**PWAs provide app-like experiences with offline support, installability, and improved performance through service workers.**

### When to implement PWA features

✅ **Good candidates:**
- Content-heavy sites (news, blogs, documentation)
- Apps with repeat users (dashboards, productivity tools)
- Mobile-first experiences
- Apps needing offline functionality

❌ **Skip for:**
- Simple landing pages
- Admin-only tools with no mobile users
- Apps requiring real-time data with no offline fallback

### Service Worker Registration

**Pattern: Progressive enhancement with feature detection**

```typescript
// components/ServiceWorkerRegistration.tsx
"use client";

import { useEffect } from "react";

const ENABLE_IN_DEV = process.env.NEXT_PUBLIC_ENABLE_SW_IN_DEV === "true";

export default function ServiceWorkerRegistration() {
  useEffect(() => {
    // Feature detection
    if (!("serviceWorker" in navigator)) return;
    
    // Environment check (production-only by default)
    if (process.env.NODE_ENV !== "production" && !ENABLE_IN_DEV) return;

    const register = async () => {
      try {
        const registration = await navigator.serviceWorker.register("/sw.js", {
          scope: "/",
        });

        // Handle waiting worker (update available)
        if (registration.waiting) {
          registration.waiting.postMessage({ type: "SKIP_WAITING" });
        }

        // Listen for updates
        registration.addEventListener("updatefound", () => {
          const installingWorker = registration.installing;
          if (!installingWorker) return;
          
          installingWorker.addEventListener("statechange", () => {
            if (
              installingWorker.state === "installed" &&
              navigator.serviceWorker.controller
            ) {
              // New version available, activate immediately
              installingWorker.postMessage({ type: "SKIP_WAITING" });
            }
          });
        });
      } catch (error) {
        console.error("Service worker registration failed", error);
      }
    };

    register();
  }, []);

  return null;
}
```

### PWA Manifest

**Minimal manifest for installability:**

```typescript
// app/manifest.ts (Next.js example)
import { MetadataRoute } from 'next';

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: 'Your App Name',
    short_name: 'App',
    description: 'Your app description',
    start_url: '/',
    display: 'standalone',
    background_color: '#ffffff',
    theme_color: '#000000',
    icons: [
      {
        src: '/icons/pwa-192x192.png',
        sizes: '192x192',
        type: 'image/png',
      },
      {
        src: '/icons/pwa-512x512.png',
        sizes: '512x512',
        type: 'image/png',
      },
      {
        src: '/icons/pwa-512x512-maskable.png',
        sizes: '512x512',
        type: 'image/png',
        purpose: 'maskable', // For Android adaptive icons
      },
    ],
  };
}
```

### Service Worker Caching Strategy

**Pattern: Cache-first for static assets, network-first for dynamic content**

```javascript
// public/sw.js (simplified example)
const CACHE_NAME = 'app-v1';
const STATIC_ASSETS = [
  '/',
  '/offline.html',
  '/icons/pwa-192x192.png',
];

// Install: cache static assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(STATIC_ASSETS))
  );
  self.skipWaiting(); // Activate immediately
});

// Activate: clean up old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key))
      )
    )
  );
  self.clients.claim();
});

// Fetch: cache-first for static, network-first for dynamic
self.addEventListener('fetch', (event) => {
  const { request } = event;
  
  // Cache-first for static assets
  if (request.url.includes('/icons/') || request.url.includes('/static/')) {
    event.respondWith(
      caches.match(request).then((cached) => cached || fetch(request))
    );
    return;
  }
  
  // Network-first for dynamic content
  event.respondWith(
    fetch(request)
      .then((response) => {
        // Cache successful responses
        if (response.ok) {
          const clone = response.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(request, clone));
        }
        return response;
      })
      .catch(() => {
        // Fallback to cache on network failure
        return caches.match(request).then((cached) => {
          return cached || caches.match('/offline.html');
        });
      })
  );
});
```

### PWA Checklist

- [ ] Service worker registered with feature detection
- [ ] Manifest file with required fields (name, icons, start_url, display)
- [ ] Icons in multiple sizes (192x192, 512x512, maskable variant)
- [ ] Offline fallback page (`/offline.html`)
- [ ] HTTPS enabled (required for service workers)
- [ ] Caching strategy defined (cache-first vs network-first)
- [ ] Update mechanism (SKIP_WAITING message handling)
- [ ] Install prompt (optional, for custom install UI)
- [ ] Tested on mobile devices (iOS Safari, Android Chrome)
- [ ] Service worker disabled in development (unless explicitly enabled)

### Performance Impact

**Benefits:**
- Faster repeat visits (cached assets)
- Offline functionality
- Reduced server load
- Improved perceived performance

**Costs:**
- Initial service worker registration overhead (~50-100ms)
- Cache storage usage (monitor with `navigator.storage.estimate()`)
- Complexity in debugging (service worker lifecycle)

### Common Pitfalls

**Service worker caching too aggressively** — users see stale content. Use versioned cache names and clear old caches on activate.

**Not handling updates** — users stuck on old version. Implement SKIP_WAITING and prompt for reload.

**Caching API responses** — can cause stale data. Use network-first for dynamic content.

**Forgetting HTTPS** — service workers require HTTPS (except localhost).

**Not testing offline** — use DevTools Network tab to simulate offline and verify fallback works.

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
- [ ] PWA features implemented if applicable (service worker, manifest, offline support)

---

## Common Pitfalls

**Optimizing without measuring** — always profile first; guess-and-check wastes time.

**Over-optimizing images** — 85% quality JPEG is visually identical to lossless for most content.

**Ignoring mobile** — desktop Lighthouse scores can be misleading; test on real low-end devices.

**Eager-loading everything** — lazy loading below-fold content is the single highest-ROI optimization in most apps.

**Third-party script accumulation** — every analytics tag, chat widget, and A/B test tool adds to TBT; audit these regularly.

---

## When to Escalate

Ask for human review when:
- Core Web Vitals consistently fail despite targeted optimizations
- Bundle size exceeds budget but all dependencies appear necessary
- Performance issues only reproduce in production, not locally
- Trade-offs between performance and required functionality are unclear
- Third-party scripts are required but severely impact metrics

---

## Framework-Specific Notes

> These sections show how the principles above apply in specific frameworks. The principles are the same; syntax differs.

### Next.js (React/TypeScript)

```javascript
// Dynamic imports for code splitting
import dynamic from 'next/dynamic'
const HeavyChart = dynamic(() => import('./HeavyChart'), {
  loading: () => <Spinner />,
  ssr: false
})

// Optimized images — handles format, sizing, lazy load automatically
import Image from 'next/image'
<Image src="/hero.jpg" alt="Hero" width={1200} height={600} priority />    // LCP image
<Image src="/card.jpg" alt="Card" width={400} height={300} />              // lazy by default

// Font optimization
import { Inter } from 'next/font/google'
const inter = Inter({ subsets: ['latin'] })

// ISR — page-level caching
export const revalidate = 3600

// Non-critical third-party scripts
import Script from 'next/script'
<Script src="https://www.googletagmanager.com/gtag/js" strategy="lazyOnload" />

// Bundle analyzer
// ANALYZE=true npm run build  (requires @next/bundle-analyzer in next.config.js)

// Performance budgets in next.config.js
module.exports = {
  images: { formats: ['image/avif', 'image/webp'] },
  experimental: { optimizeCss: true }
}
```

### Astro

```javascript
// Islands architecture — ship zero JS by default, hydrate only what's interactive
---
import HeavyComponent from './HeavyComponent.jsx'
---
<HeavyComponent client:visible />   // Hydrate when visible
<HeavyComponent client:idle />      // Hydrate during browser idle time
<HeavyComponent client:load />      // Hydrate immediately (use sparingly)

// Optimized images
import { Image } from 'astro:assets'
<Image src={import('./photo.jpg')} alt="Photo" width={800} height={600} />

// Static generation by default — no JS shipped unless a component opts in
```

### Lighthouse CI (any framework)

```yaml
# .github/workflows/lighthouse.yml
name: Lighthouse CI
on: [pull_request]
jobs:
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm install && npm run build
      - run: npm install -g @lhci/cli
      - run: lhci autorun
```

```json
// .lighthouserc.json
{
  "ci": {
    "assert": {
      "assertions": {
        "largest-contentful-paint": ["error", {"maxNumericValue": 2500}],
        "cumulative-layout-shift": ["error", {"maxNumericValue": 0.1}],
        "total-blocking-time": ["error", {"maxNumericValue": 300}],
        "categories:performance": ["error", {"minScore": 0.9}]
      }
    }
  }
}
```

---

## Further Reading

- [web.dev/performance](https://web.dev/performance/) — Google's authoritative frontend performance guide
- [Core Web Vitals](https://web.dev/vitals/) — official metric definitions and thresholds
- [web-vitals library](https://github.com/GoogleChrome/web-vitals) — measure CWV in real users' browsers
- [Lighthouse CI](https://github.com/GoogleChrome/lighthouse-ci) — automate performance budgets
- [Bundlephobia](https://bundlephobia.com/) — check package size before installing
- [High Performance Browser Networking](https://hpbn.co/) — networking fundamentals
