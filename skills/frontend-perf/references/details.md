# @frontend-perf — Detailed Reference

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

**Common causes**:
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

**Common causes**:
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

Run a bundle analyzer before optimizing:
- webpack: `@next/bundle-analyzer`, `webpack-bundle-analyzer`
- Rollup/Vite: `rollup-plugin-visualizer`
- Check package size before adding a dependency: [bundlephobia.com](https://bundlephobia.com)

### Core strategies

**Tree shaking** — prefer named imports from ES modules over default imports of entire libraries. When a utility can be written in a few lines, prefer that over importing a large library.

**Code splitting by route** — each route/page should only load the JavaScript it needs.

**Lazy load below-the-fold content** — wrap in lazy/dynamic imports with a loading fallback.

**Choose lighter alternatives**:
- `date-fns` or `dayjs` over `moment`
- native `fetch` over `axios`
- native array methods over utility libraries

---

## Image Optimization

- Serve in modern formats (AVIF → WebP → JPEG/PNG fallback)
- Always specify width and height to prevent layout shift
- Use responsive images (`srcset` + `sizes`) for different viewports
- Lazy load below-fold images (`loading="lazy"`); eager-load the LCP image
- Compress at 80–85% quality — usually indistinguishable from lossless

---

## JavaScript Performance

### Minimize main thread work

Long tasks (>50ms) block interactivity:
- Move heavy computation to Web Workers
- Break large loops into chunks and yield between them (`setTimeout(0)` or `scheduler.yield()`)
- Debounce expensive event handlers (resize, scroll, input)
- Throttle operations that fire continuously

### Optimize re-renders

- Memoize expensive derived values
- Stabilize function references passed as props
- Use shallow equality for re-render comparison
- Virtualize long lists — render only visible items

---

## CSS Performance

**Critical CSS** — inline above-the-fold CSS in `<head>`; load the rest asynchronously.

**Remove unused CSS** — use a tool that strips CSS classes never referenced. Most JIT frameworks (Tailwind) do this automatically with correct content paths configured.

**Avoid runtime CSS-in-JS on critical paths** — prefer zero-runtime alternatives (vanilla-extract, linaria) or CSS Modules.

---

## Caching Strategies

**HTTP caching** — static assets with content-hashed filenames: `Cache-Control: public, max-age=31536000, immutable`. HTML: `no-cache` with revalidation.

**Service worker caching** — cache-first for static assets, network-first for API data. Use only when you have a clear offline or performance requirement.

**Client-side data caching** — use SWR, React Query, or Apollo. Don't reinvent with raw `useEffect` + `useState`.

---

## Third-Party Scripts

- Load non-critical scripts with `async` or `defer`
- Use `lazyOnload` for analytics and ads
- Use the **facade pattern** for heavy embeds (YouTube, maps, chat): show a thumbnail, load the real embed on click

---

## Framework-Specific Notes

### Next.js (React/TypeScript)

```javascript
// Dynamic imports for code splitting
import dynamic from 'next/dynamic'
const HeavyChart = dynamic(() => import('./HeavyChart'), {
  loading: () => <Spinner />,
  ssr: false
})

// Optimized images
import Image from 'next/image'
<Image src="/hero.jpg" alt="Hero" width={1200} height={600} priority />   // LCP image
<Image src="/card.jpg" alt="Card" width={400} height={300} />             // lazy by default

// Font optimization
import { Inter } from 'next/font/google'
const inter = Inter({ subsets: ['latin'] })

// ISR — page-level caching
export const revalidate = 3600

// Non-critical third-party scripts
import Script from 'next/script'
<Script src="https://www.googletagmanager.com/gtag/js" strategy="lazyOnload" />

// Performance budgets in next.config.js
module.exports = {
  images: { formats: ['image/avif', 'image/webp'] },
  experimental: { optimizeCss: true }
}
```

---

## Further Reading

- [web.dev/performance](https://web.dev/performance/) — Google's authoritative frontend performance guide
- [Core Web Vitals](https://web.dev/vitals/) — official metric definitions
- [web-vitals library](https://github.com/GoogleChrome/web-vitals) — measure CWV in real users' browsers
- [Lighthouse CI](https://github.com/GoogleChrome/lighthouse-ci) — automate performance budgets
- [Bundlephobia](https://bundlephobia.com/) — check package size before installing
- [High Performance Browser Networking](https://hpbn.co/) — networking fundamentals
